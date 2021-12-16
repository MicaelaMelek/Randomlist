<template>
  <span class="badge track rounded-pill bg-primary p-2 m-1">{{artistName}} - {{trackName}} <i class="bi bi-x" v-on:click="$emit('removeTrack')"></i></span>
</template>

<script>

export default {
 props: {
   artistName: {
     required: true
   },
   trackName: {
     required: true
   }
 },
}
</script>

<style scoped>
.badge {
  font-size: 14px;
}

.badge i {
  cursor: pointer;
}

.track {
  background-color: #1DB954 !important;
}
</style>