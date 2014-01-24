module CarrierWave
  module MiniMagick

    def crop_and_resize(x, y, width, height, new_width, new_height)
      manipulate! do |img|
        img.combine_options do |i|
          i.crop "#{width}x#{height}+#{x}+#{y}!"
          i.resize "#{new_width}x#{new_height}"
        end
      end
    end

    # Creates the default crop image.
    # Here the original crop area dimensions are restored and assigned to the model's instance.
    def resize_to_fill_and_save_dimensions(new_width, new_height)
      manipulate! do |img|
        width, height = img[:dimensions]
        img.combine_options do |i|
          if new_width != width || new_height != height
            scale_x = new_width/width.to_f
            scale_y = new_height/height.to_f
            if scale_x >= scale_y
              cols = (scale_x * (width + 0.5)).round
              rows = (scale_x * (height + 0.5)).round
              i.resize "#{cols}"
            else
              cols = (scale_y * (width + 0.5)).round
              rows = (scale_y * (height + 0.5)).round
              i.resize "x#{rows}"
            end
          end
          i.gravity 'Center'
          i.background "rgba(255,255,255,0.0)"
          i.extent "#{new_width}x#{new_height}" if cols != new_width || rows != new_height
        end
        w_ratio = width.to_f / new_width.to_f
        h_ratio = height.to_f / new_height.to_f

        ratio = [w_ratio, h_ratio].min

        self.w = ratio * new_width
        self.h = ratio * new_height
        self.x = (width - self.w) / 2
        self.y = (height - self.h) / 2

        img
      end
    end
  end
end