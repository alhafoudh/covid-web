module ApplicationHelper
  def image_srcset_tag(source, options = {})
    image_tag(
      source,
      {
        srcset: [
          srcset_variant(source, '2x'),
          srcset_variant(source, '3x'),
        ].reduce({}, :merge)
      }.merge(options)
    )
  end

  def srcset_variant(source, variant)
    base_name = File.basename(source, '.*')
    ext_name = File.extname(source)
    { "#{base_name}@#{variant}#{ext_name}" => variant }
  end

  def gtm_script_tag
    return unless Rails.application.config.x.analytics.gtm_code.present?

    "
  <!-- Google Tag Manager -->
  <script>(function (w, d, s, l, i) {
    w[l] = w[l] || [];
    w[l].push({
      'gtm.start':
        new Date().getTime(), event: 'gtm.js'
    });
    var f = d.getElementsByTagName(s)[0],
      j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : '';
    j.async = true;
    j.src =
      'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
    f.parentNode.insertBefore(j, f);
  })(window, document, 'script', 'dataLayer', '#{Rails.application.config.x.analytics.gtm_code}');</script>
  <!-- End Google Tag Manager -->
".html_safe
  end

  def gtm_noscript_tag
    return unless Rails.application.config.x.analytics.gtm_code.present?

    "
<!-- Google Tag Manager (noscript) -->
<noscript>
  <iframe src=\"https://www.googletagmanager.com/ns.html?id=#{Rails.application.config.x.analytics.gtm_code}\"
          height=\"0\" width=\"0\" style=\"display:none;visibility:hidden\"></iframe>
</noscript>
<!-- End Google Tag Manager (noscript) -->
".html_safe
  end

  def firebase_app_config
    FirebaseController.render('firebase/configuration')
  end

  def sentry_config_tag
    return unless Rails.application.config.x.sentry.js_dsn.present?

    javascript_tag %{
      window.sentryDsn = '#{Rails.application.config.x.sentry.js_dsn}';
    }
  end

  def firebase_app_config_tag
    return unless Rails.application.config.x.firebase.api_key.present?

    javascript_tag %{
      #{firebase_app_config}
      window.firebaseVapidKey = '#{Rails.application.config.x.firebase.vapid_key}';
    }
  end

  def js_strings_tag
    strings = {
      'notifications.errors.title': t('notifications.errors.title'),
      'notifications.errors.disabled_in_browser': t('notifications.errors.disabled_in_browser'),
      'notifications.errors.not_allowed': t('notifications.errors.not_allowed'),
    }

    javascript_tag %{
      window.strings = #{strings.to_json}
    }
  end
end
