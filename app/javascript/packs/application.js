// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Vue from 'vue';
import Vuex from "vuex";
import { createInertiaApp } from '@inertiajs/inertia-vue'
import { InertiaProgress } from '@inertiajs/progress'

var token = document.querySelector('meta[name="csrf-token"]').content
Vue.use(Vuex)

window.store = new Vuex.Store({
    state: {
        artistsSelected: [],
        tracksSelected: []
    },

    getters: {
        albumIds: state => {
            if (state.artistsSelected.length === 0) return []
            return state.artistsSelected.map(artist => artist.selectedAlbums).flat()
        },
        artistIds: state => {
            if (state.artistsSelected.length === 0) return []
            return state.artistsSelected.map(artist => artist.id).flat()
        },
        trackIds: state => {
            if (state.tracksSelected.length === 0) return []
            return state.tracksSelected.map(track => track.id)
        }
    },

    mutations: {
        updateAlbums(state, data) {
            const artistIndex = state.artistsSelected.findIndex(
                (artist) => artist.id === data.artistId
            )
            if (artistIndex !== -1) {
                Vue.set(state.artistsSelected[artistIndex], 'selectedAlbums', data.albums)
            }
        },
        addArtist(state, artist) {
            state.artistsSelected.push(artist)
        },
        removeArtist(state, artistId) {
            const artistIndex = state.artistsSelected.findIndex(
                (artist) => artist.id === artistId
            )
            if (artistIndex !== -1) {
                state.artistsSelected.splice(artistIndex, 1)
            }
        },
        addTrack(state, track) {
            state.tracksSelected.push(track)
        },
        removeTrack(state, trackId){
            const trackIndex = state.tracksSelected.findIndex(
                (track) => track.id === trackId
            )
            if (trackIndex !== -1) {
                state.tracksSelected.splice(trackIndex, 1)
            }
        }
    }
})

InertiaProgress.init()
createInertiaApp({
    resolve: name => require(`../pages/${name}`),
    setup({el, App, props}) {
        new Vue({
            store,
            render: h => h(App, props),
        }).$mount(el)
    },
})