module CarrierWave::Cropable
  extend ActiveSupport::Concern

  included do

    include CarrierWave::ModelDelegateAttribute

    model_delegate_attribute :x
    model_delegate_attribute :y
    model_delegate_attribute :w
    model_delegate_attribute :h
  end

  def crop_to(width,height)
    # Checks that crop area is defined and crop should be done.
    if ((crop_args[0] == crop_args[2]) || (crop_args[1] == crop_args[3]))
      # If not creates default image and saves it's dimensions.
      resize_to_fill_and_save_dimensions(width, height)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end      
  end

  private
  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end
end