<template>
  <div class="py-5 text-center container">
    <div v-if="$page.props.flash.message" class="alert alert-success alert-dismissible fade show" role="alert">
      {{ $page.props.flash.message }}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <h3 class="mb-3">Enjoy your Playlist <i class="bi bi-emoji-wink"></i></h3>
    <div>
      <div class="input-group mb-3 mx-auto">
        <span class="input-group-text" id="basic-addon1"><i class="bi bi-link-45deg"></i></span>
        <input :value="'https://open.spotify.com/playlist/' + playlist.spotify_id" type="text" id="spotify-url" class="form-control" placeholder="Username" aria-label="spotify_id" aria-describedby="basic-addon1" disabled>
        <button class="btn btn-outline-success" v-on:click="copy">{{buttonMessage}}</button>
      </div>
    </div>
    <iframe :src="'https://open.spotify.com/embed/playlist/' + playlist.spotify_id" width="600" height="380" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
  </div>
</template>

<script>
export default {
  props: {
    playlist: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      buttonMessage: 'Copy'
    }
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
    }
  }
}
</script>

<style scoped>
.input-group {
  width: 600px;
}
</style>