module SvgHelper
  def svg(options = {}, &block)
    content_tag(:svg, svg_options(options), &block)
  end

  private

  def svg_options(options)
    options.reverse_merge(xmlns: "http://www.w3.org/2000/svg")
  end
end
