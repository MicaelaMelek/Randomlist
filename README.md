# Randomlists documentation

## Authentication

For authentication, I used the **Devise** and **OmniAuth**(Spotify) gems and configured my client ID and secret that I got when I created a new application in my Spotify developer account.
I implemented a method in the user model to save the token, refresh token, and uid from the authorization data.

## Front-end
I used **Vue.js 2** and **Bootstrap 5**. I also used **Inertia.js** (https://inertiajs.com/) to map my playlist actions (from the controller) with my components (Index, Show, Edit, and New) to avoid creating an API and to be able to use rails routing instead of using the Vue router.
Path to the inertia pages: app/javascript/pages 

I created some reusable components for searching and selecting tracks and albums
These components need to obtain information from the backend. I’m using **Axios** to perform the requests.
Path to the components: app/javascript/components

I’m using **Vuex** to store the selected albums and tracks 
Path: app/javascript/packs/application.js

I used **Slim** on the welcome page.

## Backend
Gems: 
- inertia adapter for rails (https://github.com/inertiajs/inertia-rails)
- RSpec
- VCR
- Sidekiq
- RSpotify (to interact with Spotify)
- Slim-rails
- Omniauth-spotify
- Devise

### Controllers
- Three API controllers to obtain the information of the artists, albums, and tracks
- A controller to create, list, and show the playlists that use the inertia rendering (where I specify the component that I want to use and the properties that I need).

### Models

- **User model** <br />
  Contains the devise options, a method to link the user with the authorization data, and a method to get the Spotify client to create the playlist.

- **Playlist model** <br />
  Contains the ID of the Spotify playlist and the date of the unfollow There is a method with the logic to stop following the list and another method to create the Job.

### Active Models
- **NewPlaylistForm** <br />
This class has the logic to get the tracks (recommendations, global top and album tracks), create the Spotify playlist and the local playlist. And enqueue the unfollow job.

- **UpdatePlaylistForm** <br />
  This class is to update the playlist, you can add tracks or change the unfollow date.

### Jobs
- **UnfollowPlaylistJob** <br />
  A job to stop following the list (Runs on Sidekiq).

### Testing
I used RSpec and VCR (to save the requests).
- Unit test for NewPlaylistForm.
- Controllers test for the API controllers and for the playlist controller.
- Model test for the Playlist class.

## Images


https://user-images.githubusercontent.com/8550369/146258591-6c6fb833-f875-472c-b53b-5e1ef49989fa.mp4


![Randomlist](https://user-images.githubusercontent.com/8550369/146257668-331d5e66-061a-4787-8f12-4aefc07b8b6e.png)

![Randomlist (1)](https://user-images.githubusercontent.com/8550369/146257709-4183c02b-54fd-42c4-94a3-79c51c1c6332.png)

![Randomlist (8)](https://user-images.githubusercontent.com/8550369/146257855-06e16c46-4516-404c-b756-85c2190e9956.png)

![Randomlist (2)](https://user-images.githubusercontent.com/8550369/146257749-0ad180ae-46de-437c-a82a-b1a1a1b033a8.png)

![Randomlist (5)](https://user-images.githubusercontent.com/8550369/146257897-1322fa8f-36ae-4ab5-840c-c616e0425a4e.png)

![Randomlist (7)](https://user-images.githubusercontent.com/8550369/146257929-fec091bc-c53f-485b-be4c-6582cd767ad1.png)

![Randomlist (11)](https://user-images.githubusercontent.com/8550369/146257948-3cdd1de5-85f9-473f-aa48-ebcb779c609f.png)

![Randomlist (12)](https://user-images.githubusercontent.com/8550369/146257983-733f3f90-826b-47df-898e-570c99ad0fcf.png)


