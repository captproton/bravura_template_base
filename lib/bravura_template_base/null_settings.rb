# lib/bravura_template_base/null_settings.rb
module BravuraTemplateBase
  module NullSettings
    class NullBase
      def [](key)
        method_missing(key)
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end

    class NullFeature < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :page_size, :cusdis_id, :disqus_short_name, :webhook_url, :webhook_bearer_token
          nil
        when :watermark, :category_filters, :pagination, :post_sidebar, :indexing, :sitemap, :rss_feed, :site_search, :newsletter, :cta_button, :image_zoom, :image_optimization, :auto_generate_covers
          true
        when :comments, :pages_sidebar, :internal_page_sidebar, :newsletter_in_hero, :typography, :notion_page_properties, :reverse_posts_order, :collection_view_dropdown, :interactive_checkboxes, :no_follow_external_links, :rtl, :sub_directory, :hide_cta_in_content_index, :hide_cta_in_tags_index, :hide_cta_in_authors_index, :featured_posts_in_tag_page, :featured_posts_in_author_page, :api
          false
        when :newsletter_email_verification
          "[FILTERED]"
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullGeneral < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :blog_hero_description, :blog_hero_title, :meta_description, :publication_name, :tab_title, :meta_title
          "Default #{method_name.to_s.humanize}"
        when :html_lang
          "en"
        when :open_graph_locale
          "en_US"
        when :facebook_url, :x_url, :instagram_url, :linkedin_url, :pinterest_url, :tiktok_url, :telegram_url, :mastodon_url, :youtube_url
          "#"
        when :keywords
          nil
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullCtaButtonSetup < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :show_cta_button
          true
        when :cta_button_heading, :cta_button_sub_heading, :cta_button_text
          "Default #{method_name.to_s.humanize}"
        when :cta_button_link
          "#"
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullDesign < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :site_mode_id, :blog_theme_id, :shades_of_gray_id, :button_style_id, :navigation_bar_id
          1
        when :font_family
          "Default"
        when :blog_template_gem
          "default_template"
        when :heading_font, :content_font
          "DEFAULT"
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullEmailNewsletterSetup < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :email_verification, :webhook_bearer_token
          "[FILTERED]"
        when :webhook_url
          ""
        when :header_enabled, :footer_enabled
          false
        when :header_headline, :header_text, :header_disclaimer, :footer_headline, :footer_text, :footer_disclaimer
          "Default #{method_name.to_s.humanize}"
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullFooter < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :footer_description
          "Default Footer Description"
        when :sitemap, :rss_feed
          true
        when :copyright
          "Copyright © #{Time.now.year} Default Company Name"
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end

    class NullNavigation < NullBase
      def method_missing(method_name, *args)
        case method_name
        when :logo_text
          "Default Logo Text"
        when :logo_link
          "https://defaultlogolink.com"
        when :open_logo_link_in_same_tab, :hide_logo_text, :hide_logo_image
          false
        when :site_search
          true
        when :created_at, :updated_at
          Time.current
        when :account_id
          0
        else
          super
        end
      end
    end
  end
end
