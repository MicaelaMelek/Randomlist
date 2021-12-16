<template>
  <div class="py-5 text-center container">
    <div v-if="playlists.length > 0">
      <table class="table">
        <thead>
        <tr>
          <th scope="col">URL</th>
          <th>Created at</th>
          <th>Unfollow at</th>
          <th>Follow?</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="playlist in playlists" v-if="playlist.spotify_id">
          <td><Link :href="'/playlists/' + playlist.id + '/edit'" target="_blank">{{ 'https://open.spotify.com/playlist/' + playlist.spotify_id }}</Link></td>
          <td>{{ playlist.created_at }}</td>
          <td>{{ playlist.schedule_unfollow_at }}</td>
          <td><i :class="playlist.unfollow ? 'bi bi-x-circle' : 'bi bi-check-circle' "></i></td>
        </tr>
        </tbody>
      </table>
    </div>
    <div v-else><p>Upss! You have created any playlist yet <i class="bi bi-emoji-frown"></i>. Please <Link href="/playlists/new">click here</Link> to create one</p></div>
  </div>
</template>

<script>
import { Link } from '@inertiajs/inertia-vue'

export default {
  props: {
    playlists: {
      type: Array,
      required: true
    }
  },
  components: { Link }
}
</script>