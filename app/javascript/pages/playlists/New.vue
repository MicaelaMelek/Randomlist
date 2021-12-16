<template>
  <div class="py-5 text-center container">
    <div v-if="$page.props.flash.message" class="alert alert-primary alert-dismissible fade show" role="alert">
      {{ $page.props.flash.message }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <div v-if="$page.props.flash.alert" class="alert alert-danger alert-dismissible fade show" role="alert">
      {{ $page.props.flash.alert }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <h2>Create your RandomList <i class="bi bi-music-note-list"></i></h2>
    <div class="mt-3 p-4 pb-4">
      <h3>Select a name</h3>
      <input type="text" class="form-control mx-auto" id="name" aria-describedby="PlaylistName" v-model="name">
      <div class="error" v-if="errors && errors.name">{{ errors.name.join(", ") }}</div>
    </div>
    <div class="selection">
      <div>
        <ul class="nav nav-pills nav-fill">
          <li class="nav-item">
            <a :class="'nav-link' + (artistsTab ? ' active' : '') " aria-current="page" v-on:click="artistsTab = true; tracksTab = false;">Artists</a>
          </li>
          <li class="nav-item">
            <a :class="'nav-link' + (tracksTab ? ' active' : '') "  v-on:click="artistsTab = false; tracksTab = true;">Tracks</a>
          </li>
        </ul>
      </div>
      <div id="album" class="mt-5" v-if="artistsTab">
        <h3><i class="bi bi-stars"></i> Search an Artist and select the album(s) <i class="bi bi-stars"></i></h3>
        <Search v-on:artistSelected="onArtistSelected"></Search>
        <div id="album-list" v-if="this.$store.state.artistsSelected.length > 0" class="mt-3 mb-5">
          <transition-group  id="album-list" name="fade" class="row justify-content-center g-4">
              <SelectAlbum v-for="(artist, index) in this.$store.state.artistsSelected"
                         :artistId="artist.id"
                         :artistName="artist.name"
                         :artistAlbums="artist.albums"
                         :artistImage="artist.images[0] ? artist.images[0].url : ''"
                         v-on:removeArtist="onRemoveArtist(index, artist.id)"
                         :key="artist.id">

              </SelectAlbum>
            </transition-group>
          </div>
      </div>
      <div id="track" class="mt-5 w-100 d-flex justify-content-center align-items-center flex-column" v-if="tracksTab">
        <h3>Do you want to select a track? <i class="bi bi-music-note-beamed"></i></h3>
        <SearchTrack class="p-4" v-on:trackSelected="onTrackSelected" :selectedTracks="this.$store.getters.trackIds">
        </SearchTrack>
        <div id="track-list" v-if="this.$store.state.tracksSelected.length > 0" class="mb-5">
          <Track v-for="(track, index) in this.$store.state.tracksSelected"
                 :key="track.id"
                 :artistName="track.artistName"
                 :trackName="track.name"
                 v-on:removeTrack="onRemoveTrack(index, track.id)"
          >
          </Track>
        </div>
      </div>
    </div>
    <div id="options" class="mt-3 mb-3 vstack gap-3">
      <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" v-model="addTopGlobal">
        <label class="form-check-label">Add the top 25 global tracks</label>
      </div>
      <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" :disabled="recommendationOptionDisabled" v-model="addRecommendations">
        <label class="form-check-label">Add recommendations based on your selection</label>
      </div>
      <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" v-model="schedule_unfollow">
        <label class="form-check-label">Delete Playlist after 5 days</label>
      </div>
    </div>
    <button type="button" class="btn btn-green mt-3" :disabled="createButtonIsDisabled" v-on:click="createPlaylist">Create</button>
  </div>
</template>

<script>
import Search from '../../components/Search'
import SelectAlbum from '../../components/SelectAlbum'
import SearchTrack from '../../components/SearchTrack'
import Track from '../../components/Track'

export default {
  components: { Search, SelectAlbum, SearchTrack, Track },
  props: {
    errors: Object,
  },
  data() {
    return {
      name: '',
      addTopGlobal: false,
      addRecommendations: false,
      schedule_unfollow: false,
      artistsTab: true,
      tracksTab: false
    }
  },
  computed: {
    user() {
      return this.$page
    },
    createButtonIsDisabled() {
      return !((this.$store.getters.albumIds.length + this.$store.getters.trackIds.length) > 0 || this.addTopGlobal || this.addRecommendations);
    },
    recommendationOptionDisabled() {
      return ((this.$store.getters.albumIds.length + this.$store.getters.trackIds.length)) === 0
    },
  },
  watch: {
    recommendationOptionDisabled(value) {
      if (value) this.addRecommendations = false
    }
  },
  methods: {
    onArtistSelected(artist) {
      this.$store.commit('addArtist', artist)
    },
    onTrackSelected(track) {
      this.$store.commit('addTrack', track)
    },
    onRemoveTrack(index, trackId) {
      this.$store.commit('removeTrack', trackId)
    },
    onRemoveArtist(index, artistId) {
      this.$store.commit('removeArtist', artistId)
    },
    createPlaylist() {
      this.$inertia.post('/playlists', {
        name: this.name,
        tracks: this.$store.state.tracksSelected,
        albums: this.$store.getters.albumIds,
        add_global_top: this.addTopGlobal,
        add_recommendations: this.addRecommendations,
        schedule_unfollow: this.schedule_unfollow,
      })
    }
  }
}
</script>

<style scoped>
.form-check-input {
  float: none;
}

#name {
  width: 500px;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.error {
  color: red;
}

.selection .nav-item {
  margin: 0.50em;
  flex: none;
}

.nav-link.active {
  background-color: #1db954;
}

.selection .nav-pills {
  justify-content: center;
}

.search-track-container {
  display: flex;
  justify-content: center;
  align-content: center;
}

.nav-link {
  color: #1db954;
  cursor: pointer;
}
</style>