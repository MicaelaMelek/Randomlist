<template>
  <div>
    <div class="w-100 p-4 d-flex justify-content-center align-items-center flex-column">
      <div class="d-flex position-relative">
        <input v-model="artist" class="form-control me-2 search" type="search" placeholder="Search an artist" aria-label="Search" v-on:keyup.enter="getArtists">
        <button class="btn btn-outline-green" type="submit" v-on:click="getArtists">Search</button>
        <transition name="fade">
          <ul class="list-group" v-if="artists.length">
              <li class="list-group-item" v-for="artist in artists" :key="artist.id" v-on:click="selectArtist(artist)" :class="isArtistSelected(artist.id) ? 'disabled' : ''">
                <div class="float-start">
                  <img class="rounded-circle" v-if="artist.images[2]" :src=" artist.images[2].url" height="45" width="45" alt="artist-image" /> {{ artist.name }}
                </div>
              </li>
          </ul>
        </transition>
      </div>
    </div>
    <span v-if="errorMessage">{{errorMessage}}</span>
    <div class="d-flex justify-content-center" v-if="loading">
      <div class="spinner-border" role="status">
        <span class="sr-only"></span>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      artist: '',
      artists: [],
      errorMessage: '',
      loading: false
    }
  },
  watch: {
    artist: function () {
      this.errorMessage = ''

      if (this.artist === '') {
        this.artists = []
      } else {
        this.debouncedGetArtist()
      }
    }
  },
  created: function () {
    this.debouncedGetArtist = _.debounce(this.getArtists, 800)
  },
  methods: {
    getArtists() {
      // This is in a meta tag located within the head tags
      //var token = document.querySelector('meta[name="csrf-token"]').content
      if (this.artist !== '') {
        axios.get('/api/v1/artists', {
          params: {
            artist: this.artist
          }})
            .then((response) => {
              if (response.data.length !== 0) {
                this.artists = response.data
              } else {
                this.errorMessage = 'We did not find any artist for ' + this.artist
              }
            })
            .catch((error) => {
              console.log(error);
              this.errorMessage = 'Sorry, we found an error ' + error
            })
      }
    },
    selectArtist(artist) {
      if (this.isArtistSelected(artist.id)) return;
      this.loading = true;
      axios.get('/api/v1/artists/' + artist.id + '/albums', {})
          .then((response) => {
            if (response.data.length !== 0) {
              artist.albums = response.data
            } else {
              artist.albums = {}
            }
            this.$emit('artistSelected', artist)
          })
          .catch((error) => {
            console.log(error);
            this.errorMessage = 'Sorry, we found an error ' + error
          }).finally(() => {
            this.loading = false
          })

      this.artists = []
      this.artist = ''
    },
    isArtistSelected(artistId)  {
      let artistIndex = -1
      let artistIds = this.$store.getters.artistIds
      if (artistIds.length > 0 && artistId) {
         artistIndex = artistIds.findIndex(
            (artist) => artist === artistId
        )
      }
      return artistIndex >= 0
    }
  }
}
</script>

<style scoped>
  .search {
    width: 500px
  }

  .list-group {
    width: 500px;
    position: absolute;
    z-index: 99;
    top: 100%;
    left: 0;
    right: 0;
  }

  .spinner-border {
    color: #1DB954;
  }

  .fade-enter-active, .fade-leave-active {
    transition: opacity .3s;
  }
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }

  .disabled {
    background-color: #e9ecef;
    opacity: 1;
  }
</style>