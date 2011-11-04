require 'sass'

module Meatloaf

  # An Ingredient is simply one of the images to be compiled into the Sprite.
  class Ingredient

    attr_accessor :width, :height, :x_offset, :y_offset, :image_path

    def initialize(image_css_url, x_offset = 0, y_offset = 0)
      @x_offset = x_offset
      @y_offset = y_offset

      # Find the asset associated with image_css_url.
      asset = Rails.application.assets.find_asset(image_css_url)
      raise ArgumentError.new("Can't find asset: #{image_css_url}") unless asset
      @image_path = asset.pathname.to_s
      
      # Get the dimensions of the image.
      @width, @height = `identify -format "%w %h" '#{@image_path}'`.chomp.split(' ').collect { |i| i.to_i }
    end
  end

  class Sprite

    def initialize(group, css_name)
      @group = group
      @css_name = css_name
      @ingredients = {}
      @height = 0
    end

    # Add an image to this sprite. Returns CSS for 'background: '
    def add_image(image_css_url)
      return get_css_for(@ingredients[image_css_url]) if @ingredients[image_css_url]

      # For now, just place the image at the bottom of the sprite. 
      # TODO: improve positioning algorithm
      ingredient = Ingredient.new(image_css_url, 0, @height)
      @height += ingredient.height
      @ingredients[image_css_url] = ingredient
      get_css_for(ingredient)
    end

    def finalize!
      # Create ImageMagick command.
      final_image_path = "#{Rails.root}/app/assets/images/#{filename}"
      input_files_string = @ingredients.values.collect{ |ing| "'#{ing.image_path}'" }.join(' ')
      command = "convert #{input_files_string} -append '#{final_image_path}'"
      `#{command}`
    end

    private

    def filename
      "#{@css_name}-#{@group}-sprite.png"
    end

    def offset_string(offset)
      offset == 0 ? "0" : "-#{offset}px"
    end

    def full_offset_string(ingredient)
      "#{offset_string(ingredient.x_offset)} #{offset_string(ingredient.y_offset)}"
    end

    # Returns the CSS that follows "background: "
    def get_css_for(ingredient)
      Sass::Script::String.new("url(#{filename}) no-repeat #{full_offset_string(ingredient)}")
    end
  end

  class Base

    def initialize(css_filename)
      # Convert 'NameOfcss.css.scss' to just 'nameofcss'
      @css_name = css_filename.gsub(/\..*/, '').downcase
      @sprites = {}
    end

    # Add image to sprite. Returns CSS for 'background: '
    def add_image(image_css_url, group = "base")
      image_css_url.strip!
      group = group.strip.downcase
      (@sprites[group] ||= Sprite.new(group, @css_name)).add_image(image_css_url)
    end

    # Generate all the final Sprite images. 
    def finalize!
      @sprites.values.each { |sprite| sprite.finalize! }
    end
  end

  # Module for adding some monkey-patch processing to the Sass Engine.
  module Engine
    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :meatloaf
      end
    end

    def render_with_meatloaf
      rendered = render_without_meatloaf
      options[:meatloaf].finalize! if options[:meatloaf]
      rendered
    end
  end
end

module Sass::Script::Functions
  def meatloaf(exp)
    assert_type exp, :String

    # Initialize Meatloaf for this stylesheet.
    ml = (options[:meatloaf] ||= 
          Meatloaf::Base.new(options[:importer].context.pathname.basename.to_s))

    exp_array = exp.value.split(':')
    if exp_array.size == 1
      # No group supplied.
      ml.add_image(exp_array[0])
    elsif exp_array.size == 2
      # Group and URL supplied.
      ml.add_image(exp_array[1], exp_array[0])
    else
      raise ArgumentError.new("Expected [group:]url")
    end
  end
  declare :meatloaf, [:exp]
end

class Sass::Engine
  include Meatloaf::Engine
end

