module Locomotive
  class RteInput < ::SimpleForm::Inputs::Base

    def input(wrapper_options)
      input_html_options[:class] << 'form-control'
      toolbar_html + @builder.text_area(attribute_name, input_html_options)
    end

    def toolbar_html
      template.render(
        partial:  'locomotive/shared/rte/toolbar',
        locals:   {
          wysihtml5_prefix: wysihtml5_prefix,
          link_popover:     link_popover,
          image_popover:    image_popover,
        })
    end

    def wysihtml5_prefix
      "#{object_name}_#{attribute_name}"
    end

    def image_popover
      remove_form(template.render(
        partial:  'locomotive/shared/rte/image_popover',
        locals:   { image_form: ImageForm.new }
      )).html_safe
    end

    def link_popover
      remove_form(template.render(
        partial:  'locomotive/shared/rte/link_popover',
        locals:   { link_form: LinkForm.new }
      )).html_safe
    end

    def remove_form(template)
      template.gsub(/<form([^<]*)>/, '')
        .gsub(/<input name="(utf8|authenticity_token)"([^<]*)>/, '')
        .gsub('</form>', '')
    end

    class LinkForm < Struct.new(:url, :target, :title)
      include ActiveModel::Model
    end

    class ImageForm < Struct.new(:src, :title, :alignment)
      include ActiveModel::Model
    end
  end
end
