# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
    SELECT artist
    FROM albums
    JOIN tracks ON tracks.album = albums.asin
    WHERE tracks.song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
    SELECT artist
    FROM albums
    JOIN tracks ON tracks.album = albums.asin
    WHERE tracks.song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
    SELECT song
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    WHERE albums.title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
    SELECT title, COUNT(song)
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    WHERE song like '%Heart%'
    GROUP BY title
    ORDER BY COUNT(song) Desc, title asc
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
    SELECT song
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    WHERE song = albums.title
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
    SELECT distinct title
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    WHERE title = artist
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
    SELECT distinct song, COUNT(distinct albums)
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    GROUP BY song
    HAVING COUNT(distinct albums) > 2
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
    SELECT title, price, COUNT(song)
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    GROUP BY title, price
    HAVING price/ COUNT(song) < 0.5

  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
    SELECT title, COUNT(song)
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    GROUP BY title
    ORDER BY COUNT(song) DESC, title Desc
    LIMIT 10
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
    SELECT artist, COUNT(DISTINCT albums.asin)
    FROM tracks
    JOIN albums on tracks.album = albums.asin
    JOIN styles on styles.album = albums.asin
    WHERE style like '%Rock%'
    GROUP BY artist
    ORDER BY COUNT(title) DESC
    LIMIT 1
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    SELECT style, (SUM(album_track_counts.price) / SUM(album_track_counts.count))
    FROM styles
    JOIN (
      SELECT albums.*, COUNT(tracks.*) as count
      FROM albums
      JOIN tracks ON tracks.album = albums.asin
      WHERE albums.price IS Not NULL
      GROUP BY albums.asin
    ) AS album_track_counts ON styles.album = album_track_counts.asin

    GROUP BY styles.style
    ORDER BY (SUM(album_track_counts.price) / SUM(album_track_counts.count)) DESC
    LIMIT 5
  SQL
end