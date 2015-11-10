# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    movies.title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    movies.title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
    AND castings.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    movies.title,
    actors.name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    castings.ord = 1
    AND movies.yr = 1962
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    movies.yr,
    COUNT(movies.title)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'John Travolta'
  GROUP BY
    movies.yr
  HAVING
    COUNT(movies.title) >= 2


  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    movies.title,
    lead_actors.name
  FROM
    actors AS julie_actors
  JOIN
    castings AS julie_castings ON julie_castings.actor_id = julie_actors.id
  JOIN
    movies ON movies.id = julie_castings.movie_id
  JOIN
    castings AS lead_castings ON movies.id = lead_castings.movie_id
  JOIN
    actors AS lead_actors ON lead_castings.actor_id = lead_actors.id
  WHERE
    lead_castings.ord = 1
  AND
    julie_actors.name = 'Julie Andrews'
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    actors.name
  FROM
    actors
  JOIN
    castings ON actors.id = castings.actor_id
  WHERE
    castings.ord = 1
  GROUP BY
    actors.name
  HAVING
    COUNT(castings.ord) >= 15
  ORDER BY
    actors.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SELECT
    movies.title,
    actor_count.count
  FROM
    movies
  JOIN
    (SELECT
      movies.id AS movie_id,
      COUNT(castings.actor_id) count
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    GROUP BY
      movies.id
    ) AS actor_count ON movies.id = actor_count.movie_id
  WHERE
    movies.yr = 1978
  ORDER BY
    actor_count.count DESC,
    movies.title
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SELECT
    actors.name
  FROM
    actors
  JOIN
    castings ON actors.id = castings.actor_id
  JOIN
    castings AS garfunkel_castings ON castings.movie_id = garfunkel_castings.movie_id
  JOIN
    actors AS garfunkel_actors ON garfunkel_castings.actor_id = garfunkel_actors.id
  WHERE
    garfunkel_actors.name = 'Art Garfunkel'
    AND actors.name != garfunkel_actors.name
  SQL
end
