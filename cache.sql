CREATE DATABASE movie_cache;

CREATE TABLE movies(
  id SERIAL PRIMARY KEY,
  title TEXT,
  imdbID TEXT,
  poster TEXT,
  plot TEXT,
  year_publish VARCHAR(255)
);