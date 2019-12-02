mapboxgl.accessToken =
  "pk.eyJ1IjoiY3J1bmNoeXBhbmNha2VzIiwiYSI6ImNrM25temk0YzFzMjMzcHM3bWdocXZuOXgifQ.m6zMp4CxLPXi5xp-zB1kkg";

var map = new mapboxgl.Map({
  container: "map", // HTML container id
  style: "mapbox://styles/mapbox/streets-v9", // style URL
  center: [-21.9270884, 64.1436456], // starting position as [lng, lat]
  zoom: 13
});

var popup = new mapboxgl.Popup().setHTML(
  "<h3>Reykjavik Roasters</h3><p>A good coffee shop</p>"
);

var marker = new mapboxgl.Marker()
  .setLngLat([-21.92661562, 64.14356426])
  .setPopup(popup)
  .addTo(map);
