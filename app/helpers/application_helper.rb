module ApplicationHelper
  def logo_for_tenant(tenant = current_tenant)
    url = (tenant && tenant.logo?) ? tenant.logo : "dotgeocms.png"
    image_tag url
  end
  def instance_or_new(instance, klass)
    return instance if instance.is_a?(klass)
    return klass.new
  end

  def share_link(iframe = false)
    (iframe ? "<iframe src='" : "") + "#{request.protocol}#{request.host_with_port}"
  end

  def geovisu_link
    "#{request.protocol}#{request.host_with_port}/geovisu/?wmc=#{share_link}.xml"
  end

  def breadcrumb_for_category(category = nil, admin = false)
    tpl = admin ? "parts/backend_breadcrumb" : "parts/breadcrumb"
    render tpl, :category => category
  end
end
