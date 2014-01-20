module CarrierWave::Cropable
  extend ActiveSupport::Concern

  included do

    include CarrierWave::ModelDelegateAttribute

    model_delegate_attribute :x
    model_delegate_attribute :y
    model_delegate_attribute :w
    model_delegate_attribute :h
  end

  # Crop processor
  def crop_to(width, height)
    # Checks that crop area is defined and crop should be done.
    if ((crop_args[0] == crop_args[2]) || (crop_args[1] == crop_args[3]))
      # If not creates default image and saves it's dimensions.
      resize_to_fill_and_save_dimensions(width, height)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end
  end

  def crop_and_resize(x, y, width, height, new_width, new_height)
    manipulate! do |img|
      cropped_img = img.crop(x, y, width, height)
      new_img = cropped_img.resize_to_fill(new_width, new_height)
      destroy_image(cropped_img)
      destroy_image(img)
      new_img
    end
  end

  # Creates the default crop image.
  # Here the original crop area dimensions are restored and assigned to the model's instance.
  def resize_to_fill_and_save_dimensions(new_width, new_height)
    manipulate! do |img|
      width, height = image_dimensions(img)
      new_img = img.resize_to_fill(new_width, new_height)
      destroy_image(img)

      w_ratio = width.to_f / new_width.to_f
      h_ratio = height.to_f / new_height.to_f

      ratio = [w_ratio, h_ratio].min

      self.w = ratio * new_width
      self.h = ratio * new_height
      self.x = (width - self.w) / 2
      self.y = (height - self.h) / 2

      new_img
    end
  end
  
  def image_dimensions(img)
    [img.columns, img.rows]
  end
    
  unless respond_to?(:destroy_image)  
    def destroy_image(image)
      image.destroy! if image.respond_to?(:destroy!)
    end
  end

  private
  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end
end