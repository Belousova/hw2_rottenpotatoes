class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?(:sort_by)
      if params[:sort_by] == 'title'
        @set_hilite_title='hilite'
        @set_hilite_date=''
      end
      if params[:sort_by] =='release_date'
        @set_hilite_title=''
        @set_hilite_date='hilite'
      end
      @movies = Movie.order "#{params[:sort_by]} ASC"
    else
      @set_hilite_title=''
      @set_hilite_date=''
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
   
end
