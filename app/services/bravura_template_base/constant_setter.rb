# app/services/bravura_template_base/constant_setter.rb
module BravuraTemplateBase
  class ConstantSetter
    def initialize(presenter, view_context)
      @presenter = presenter
      @view_context = view_context
    end

    def set_all
      set_meta_tags
      set_navigation
      set_footer
      set_design
      set_button_style
      set_navigation_bar
      set_template_specific_constants
    end

    private

    def set_meta_tags
      @view_context.instance_variable_set("@meta_description", @view_context.instance_variable_get("@post")&.meta_description || @presenter.get_setting("general.meta_description"))
      @view_context.instance_variable_set("@meta_title", @view_context.instance_variable_get("@post")&.meta_title || @presenter.get_setting("general.meta_title"))
    end

    def set_navigation
      @view_context.instance_variable_set("@account_settings_navigation", ActsAsTenant.current_tenant.settings_navigation)
      @view_context.instance_variable_set("@logo_text", @presenter.get_setting("navigation.logo_text"))
    end

    def set_footer
      @view_context.instance_variable_set("@copyright_notice", @presenter.get_setting("footer.copyright"))
      @view_context.instance_variable_set("@sitemap", @presenter.get_setting("footer.sitemap"))
    end

    def set_design
      @view_context.instance_variable_set("@design_settings", ActsAsTenant.current_tenant.settings_design)
      @view_context.instance_variable_set("@blog_theme", @presenter.get_setting("design.blog_theme"))
      set_site_mode
      set_shade_of_gray
      @view_context.instance_variable_set("@heading_font", @presenter.get_setting("design.heading_font"))
      @view_context.instance_variable_set("@content_font", @presenter.get_setting("design.content_font"))
      @view_context.instance_variable_set("@font_family", @presenter.get_setting("design.font_family"))
    end

    def set_site_mode
      site_mode_id = @presenter.get_setting("design.site_mode")
      site_mode = SiteMode.find_by(id: site_mode_id)
      @view_context.instance_variable_set("@site_mode_id", site_mode_id)
      @view_context.instance_variable_set("@site_mode", site_mode)
      @view_context.instance_variable_set("@site_mode_site_theme", site_mode&.site_theme || "system")
    end

    def set_shade_of_gray
      shade_of_gray_id = @presenter.get_setting("design.shades_of_gray_id")
      shade_of_gray = ShadesOfGray.find_by(id: shade_of_gray_id)
      @view_context.instance_variable_set("@shade_of_gray_id", shade_of_gray_id)
      @view_context.instance_variable_set("@shade_of_gray", shade_of_gray)
      @view_context.instance_variable_set("@shade_of_gray_name", shade_of_gray&.name&.capitalize || "Normal")
    end

    def set_button_style
      button_style_id = @presenter.get_setting("design.button_style_id")
      button_style = ButtonStyle.find_by(id: button_style_id)
      button_style_name = button_style&.name || "normal"
      @view_context.instance_variable_set("@button_radius", set_button_radius(button_style_name))
    end

    def set_button_radius(button_style)
      case button_style
      when "normal"
        "0.25rem"
      when "rounded"
        "9999px"
      when "sharp"
        "0rem"
      else
        "0.25rem"
      end
    end

    def set_navigation_bar
      navigation_bar_id = @presenter.get_setting("design.navigation_bar_id")
      navigation_bar = NavigationBar.find_by(id: navigation_bar_id)
      @view_context.instance_variable_set("@navigation_bar", navigation_bar)
      @view_context.instance_variable_set("@navigation_bar_name", navigation_bar&.name || "center")
    end

    def set_template_specific_constants
      # This method can be empty in the base class
      # Specific template engines can override this method to set their own constants
    end
  end
end
