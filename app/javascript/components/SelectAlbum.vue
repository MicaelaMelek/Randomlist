<template>
  <div class="col-lg-3 col-sm-4 col-4 mb-5">
    <div class="card">
      <div class="image-wrapper">
        <img v-bind:src="artistImage" class="card-img-top" alt="artist-photo">
        <button type="button" class="btn-close" aria-label="Close" v-on:click="$emit('removeArtist')"></button>
      </div>
      <div class="card-body">
        <h5 class="card-title">{{artistName}}</h5>
        <p class="card-text">Please select album(s)</p>
      </div>
      <ul class="list-group list-group-flush">
        <li class="list-group-item">
          <div class="d-flex justify-content-center align-items-center">
            <div>
              <i class="bi bi-shuffle"></i>
              <span class="ms-1 me-2">Select Random</span>
            </div>
            <input type="checkbox" class="form-check-input mt-0" v-model="randomAlbums" v-on:change="updateRandom">
          </div>
        </li>
        <li class="list-group-item" v-for="(album, index) in artistAlbums" v-if="index <= albumsToShow">
          <div class="d-flex justify-content-between align-items-center">
            <div class="long-and-truncated">
              <img class="rounded-circle" v-if="album.images[2]" :src=" album.images[2].url" height="30" width="30" alt="artist-image" />
              <span data-bs-toggle="tooltip" data-bs-placement="top" :title="album.name">{{ album.name }}</span>
            </div>
            <input type="checkbox" class="form-check-input mt-0" v-model="albums" :value="album.id" v-on:change="updateAlbums">
          </div>
        </li>
        <li class="list-group-item action-item" v-if="artistAlbums.length > albumsToShow" v-on:click="showMore()">Show more</li>
        <li class="list-group-item action-item" v-if="artistAlbums.length < albumsToShow" v-on:click="showLess()">Show less</li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    artistName: {
      required: true
    },
    artistImage: {
      required: true
    },
    artistId: {
      required: true
    },
    artistAlbums: {
      required: true
    },
  },
  data() {
    return {
      albums: [],
      errorMessage: '',
      randomAlbums: true,
      albumsToShow: 1
    }
  },
  methods: {
    updateAlbums() {
      if (this.albums.length === 0) {
        this.randomAlbums = true
        this.updateRandom()
      } else {
        this.randomAlbums = false
        this.$store.commit('updateAlbums', {artistId: this.artistId, albums: this.albums})
      }
    },
    updateRandom() {
      this.albums = []
      let randomAlbums = []

      if (this.randomAlbums === true) randomAlbums = _.shuffle(this.artistAlbums).map(album => album.id).slice(0,3);
      this.$store.commit('updateAlbums', {artistId: this.artistId, albums: randomAlbums})
    },
    showMore() {
      if (this.artistAlbums.length - this.albumsToShow.length < 4) this.albumsToShow = this.artistAlbums.length
      else this.albumsToShow+= 5
    },
    showLess() {
      this.albumsToShow = this.artistAlbums.length < 4 ? this.artistAlbums.length : 4
    }
  },
  mounted() {
    this.updateRandom()
    this.showLess()
  }
}
</script>

<style scoped>
  button {
    position: absolute;
    left: 94%;
    top: -5%;
    background-color: #1db954;
    border-radius: 50%;
    padding: 0.5em;
    color: white;
    opacity: .75;
    background: #1db954 url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='rgb(255,255,255)'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
  }

  .image-wrapper {
    position: relative;
  }

  .action-item {
    cursor: pointer;
    color: #1DB954
  }

  .image-wrapper img {
    padding: 1em;
    border-radius: 9%;
  }

  input[type="checkbox"] {
    border-radius: 50%;
  }

  .long-and-truncated {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: left;
  }

  .card {
    box-shadow: 0 0 7px 0.15rem #6c78703b;
  }
</style>