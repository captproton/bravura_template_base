# lib/bravura_template_base/default_settings_repository.rb

module BravuraTemplateBase
  class DefaultSettingsRepository
    DEFAULTS = {
      feature: {
        page_size: 10,
        comments: false,
        watermark: true,
        category_filters: true,
        pagination: true,
        post_sidebar: true,
        indexing: true,
        sitemap: true,
        rss_feed: true,
        site_search: true,
        newsletter: true,
        cta_button: true,
        image_zoom: true,
        image_optimization: true,
        auto_generate_covers: true
      },
      general: {
        blog_hero_description: "Welcome to our blog",
        blog_hero_title: "Our Blog",
        html_lang: "en",
        meta_description: "Default meta description",
        open_graph_locale: "en_US",
        publication_name: "Default Publication",
        tab_title: "Default Tab Title",
        meta_title: "Default Meta Title",
        facebook_url: "http://facebook.com/",
        x_url: "http://x.com/",
        instagram_url: "http://instagram.com/",
        linkedin_url: "http://linkedin.com/",
        pinterest_url: "http://pinterest.com/",
        tiktok_url: "http://tiktok.com/",
        telegram_url: "http://telegram.org/",
        mastodon_url: "http://mastodon.social/",
        youtube_url: "http://youtube.com/",
        keywords: "default, keywords"
      },
      cta_button_setup: {
        show_cta_button: true,
        cta_button_heading: "Subscribe Now",
        cta_button_sub_heading: "Get the latest updates",
        cta_button_text: "Subscribe",
        cta_button_link: "#subscribe"
      },
      design: {
        site_mode_id: 1,
        blog_theme_id: 1,
        shades_of_gray_id: 1,
        button_style_id: 1,
        navigation_bar_id: 1,
        font_family: "Arial, sans-serif",
        blog_template_gem: "bravura_template_prime",
        heading_font: "DEFAULT",
        content_font: "DEFAULT",
        template: "prime"
      },
      email_newsletter_setup: {
        header_headline: "Subscribe to our newsletter",
        header_text: "Stay updated with our latest posts",
        header_disclaimer: "We respect your privacy",
        footer_headline: "Join our mailing list",
        footer_text: "Get the latest news delivered to your inbox",
        footer_disclaimer: "Unsubscribe at any time"
      },
      footer: {
        footer_description: "Default footer description",
        sitemap: true,
        rss_feed: true,
        copyright: "© #{Time.now.year} Your Company Name"
      },
      navigation: {
        logo_text: "Your Logo",
        logo_link: "/",
        open_logo_link_in_same_tab: true,
        hide_logo_text: false,
        hide_logo_image: false,
        site_search: true
      },
      images: {
        social_cover: "bravura_template_base/defaults/social_cover.jpg",
        favicon: "bravura_template_base/defaults/default_favicon.ico"
      }
    }.freeze

    def get(key)
      category, setting = key.to_s.split(".")
      return nil if category.nil? || setting.nil?

      DEFAULTS.dig(category.to_sym, setting.to_sym)
    end

    def default_image_path(category, setting)
      DEFAULTS.dig(:images, setting.to_sym)
    end
  end
end
