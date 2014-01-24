module CarrierWave
  module RMagick

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
        width, height = img.columns, img.rows
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

  end
end
