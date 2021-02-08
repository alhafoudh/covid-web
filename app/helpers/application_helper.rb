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
end
