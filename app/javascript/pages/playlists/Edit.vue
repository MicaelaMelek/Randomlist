<template>
  <div class="py-5 text-center container">
    <div v-if="$page.props.flash.message" class="alert alert-success alert-dismissible fade show" role="alert">
      {{ $page.props.flash.message }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <div v-if="$page.props.flash.alert" class="alert alert-danger alert-dismissible fade show" role="alert">
      {{ $page.props.flash.alert }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <h3 class="mb-3">Edit</h3>

    <div class="w-100 d-flex justify-content-center align-items-center flex-column">
      <div>
        <ul class="nav nav-pills mb-3 justify-content-center mt-3" id="pills-tab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="settings" type="button" role="tab" @click="setActive('settings')" :class="{ active: isActive('settings') }">Settings</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="player" type="button" role="tab" @click="setActive('player')" :class="{ active: isActive('player') }">Player</button>
          </li>
        </ul>
        <div class="tab-content">
          <div class="tab-pane fade p-4" :class="{ ' active show': isActive('settings') }" role="tabpanel">
            <div class="form-floating">
              <VueDatePicker id="unfollow-date" v-model="unfollow_at" class="form-control" :disabled="playlist.unfollow" :placeholder="'Select a Date'" :minDate="minDate()" :color="'#1DB954'" :clearable="true"></VueDatePicker>
              <label for="unfollow-date" class="form-label">Unfollow at</label>
            </div>
            <div></div>
            <p class="error" v-if="playlist.unfollow">The Playlist is already unfollowed</p>
            <h4 class="mt-5 mb-3">Do you want to add a track? <i class="bi bi-music-note-beamed"></i></h4>
            <SearchTrack v-on:trackSelected="onTrackSelected" :selectedTracks="tracksIds"></SearchTrack>
            <div id="track-list" class="mt-3">
              <Track v-for="(track, index) in tracksToAdd"
                     :key="track.id"
                     :artistName="track.artistName"
                     :trackName="track.name"
                     v-on:removeTrack="onRemoveTrack(track.id)"
              >
              </Track>
            </div>
            <button class="btn btn-green mt-3" type="submit" v-on:click="update" :disabled="this.playlist.unfollow">Update</button>
          </div>
          <div class="tab-pane fade p-4" :class="{ ' active show': isActive('player') }" role="tabpanel">
            <div class="input-group mb-3 mx-auto">
              <span class="input-group-text" id="basic-addon1"><i class="bi bi-link-45deg"></i></span>
              <input :value="'https://open.spotify.com/playlist/' + playlist.spotify_id" type="text" id="spotify-url" class="form-control" placeholder="Username" aria-label="spotify_id" aria-describedby="basic-addon1" disabled>
              <button class="btn btn-outline-success" v-on:click="copy">{{buttonMessage}}</button>
            </div>
            <iframe :src="'https://open.spotify.com/embed/playlist/' + playlist.spotify_id" width="550" height="380" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SearchTrack from '../../components/SearchTrack'
import Track from '../../components/Track'
import { VueDatePicker } from '@mathieustan/vue-datepicker';
import '@mathieustan/vue-datepicker/dist/vue-datepicker.min.css';

export default {
  components: { SearchTrack, Track, VueDatePicker },
  props: {
    playlist: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      unfollow_at: this.playlist.schedule_unfollow_at ? new Date(this.playlist.schedule_unfollow_at).toUTCString() : undefined,
      buttonMessage: 'Copy',
      tracksToAdd: [],
      activeItem: 'settings',
    }
  },
  computed: {
    tracksIds() {
      if (this.tracksToAdd.length === 0) return []
      return this.tracksToAdd.map(track => track.id)
    },
    addTrackIsDisabled() {
      return this.tracksToAdd.length === 0
    },
  },
  methods: {
    copy() {
      let copyText = document.querySelector('#spotify-url')
      copyText.select();
      copyText.setSelectionRange(0, 99999); /* For mobile devices */
      navigator.clipboard.writeText(copyText.value);
      document.execCommand('copy');
      this.buttonMessage = "Copied!"
      setTimeout(() => this.buttonMessage = 'Copy', 2000);
    },
    onTrackSelected(track) {
      this.tracksToAdd.push(track)
    },
    onRemoveTrack(trackId) {
      const trackIndex = this.tracksToAdd.findIndex(
          (track) => track.id === trackId
      )
      if (trackIndex !== -1) {
        this.tracksToAdd.splice(trackIndex, 1)
      }
    },
    isActive (menuItem) {
      return this.activeItem === menuItem
    },
    setActive (menuItem) {
      this.activeItem = menuItem
    },
    update(data) {
      this.$inertia.put('/playlists/' + this.playlist.id, {unfollow_at: this.unfollow_at, tracks: this.tracksToAdd}, { preserveState: true })
    },
    minDate() {
      let today = new Date()
      return today.setDate(today.getDate() + 1)
    }
  }
}
</script>

<style scoped>
.tab-pane {
  width: 600px;
}

.nav-pills .nav-link.active {
  background-color: #1db954;
}

.nav-link {
  color: #1db954;
}
</style>