<template>
  <div>
    <div class="w-100 search-track-container">
      <div class="d-flex position-relative">
        <input v-model="track" class="form-control me-2 search" type="search" placeholder="Search a track" aria-label="Search" v-on:keyup.enter="getTracks">
        <button class="btn btn-outline-green" type="submit" v-on:click="getTracks">Search</button>
        <transition name="fade">
          <ul class="list-group" v-if="tracks.length">
            <li class="list-group-item" v-for="track in tracks" :key="track.id" v-on:click="selectTrack(track)" :class="isTrackSelected(track.id) ? 'disabled' : ''">
              <div class="float-start">{{track.artists[0].name}} - {{ track.name }}</div>
            </li>
          </ul>
        </transition>
      </div>
    </div>
    <span v-if="errorMessage">{{errorMessage}}</span>
  </div>
</template>

<script>
import axios from "axios";

export default {
  props: {
    selectedTracks: {
      type: Array,
      required: false,
      default: []
    }
  },
  data() {
    return {
      track: '',
      tracks: [],
      errorMessage: ''
    }
  },
  watch: {
    track: function () {
      this.errorMessage = ''

      if (this.track === '') {
        this.tracks = []
      } else {
        this.debouncedGetSong()
      }
    }
  },
  created: function () {
    this.debouncedGetSong = _.debounce(this.getTracks, 800)
  },
  methods: {
    getTracks() {
      // This is in a meta tag located within the head tags
      //var token = document.querySelector('meta[name="csrf-token"]').content
      if (this.track !== '') {
        axios.get('/api/v1/tracks', {
          params: {
            track: this.track
          }})
            .then((response) => {
              if (response.data.length !== 0) {
                this.tracks = response.data
              } else {
                this.errorMessage = 'We did not find any track for ' + this.track
              }
            })
            .catch((error) => {
              console.log(error);
              this.errorMessage = 'Sorry, we found an error ' + error
            })
      }
    },
    selectTrack(track) {
      if (this.isTrackSelected(track.id)) return;
      this.$emit('trackSelected', {id: track.id, name: track.name, artistName: track.artists[0].name, uri: track.uri, artistId: track.artists[0].id})
      this.track = ''
      this.tracks = ''
    },
    isTrackSelected(trackId)  {
      let trackIndex = -1
      let trackIds = this.selectedTracks
      if (trackIds.length > 0 && trackId) {
        trackIndex = trackIds.findIndex(
            (track) => track === trackId
        )
      }
      return trackIndex >= 0
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