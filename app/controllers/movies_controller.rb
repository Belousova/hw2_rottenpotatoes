class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@all_ratings = ['G','PG','PG-13','R']
    get_ratings
    if params.has_key?(:ratings)
      params[:ratings].keys.map{|x| @checked_boxes[x] = true}
      @movies = Movie.where(:rating => params[:ratings].keys)
      flash[:p_ratings]=params[:ratings]      
    end
    if params.has_key?(:sort_by)
      flash[:p_sort_by] = params[:sort_by]   
      if params[:sort_by] == 'title'
        @set_hilite_title='hilite'
      end
      if params[:sort_by] =='release_date'
        @set_hilite_date='hilite'
      end
      unless params[:sort_by].nil? || params[:sort_by].empty?
      if @movies.nil?
        @movies = Movie.order "#{params[:sort_by]} ASC"
      else
        @movies = @movies.order "#{params[:sort_by]} ASC" 
      end
      end 
    end
    if @movies.nil?
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
  
  def get_ratings
    @all_ratings =[] 
    Movie.select(:rating).map{|movie| @all_ratings.push movie.rating}
    @all_ratings = @all_ratings.uniq.sort
    if @checked_boxes.nil?
      @checked_boxes = {}
    end
    @all_ratings.map{|x| @checked_boxes[x] = false}
  end 
end
