module TabsHelper
  class TabStrip
    def initialize(context)
      @context = context
      @tabs = []
    end

    def tab(label, id, &block)
      @tabs << [label, id]
      @context.content_tag(:div, id: id, class: "tab-pane", &block)
    end

    def to_html
      @context.mithril_component(
        "App.Components.TabStrip",
        { tabs: @tabs },
        class: "tab-strip"
      )
    end
  end

  def tabs
    tab_strip = TabStrip.new(self)
    content = yield(tab_strip)
    content_for(:header, tab_strip.to_html)
    content_tag(:div, content, class: "tab-panes")
  end
end
