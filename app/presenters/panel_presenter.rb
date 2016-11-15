class PanelPresenter < ModelPresenter
  delegate :params, to: :view_context
  
  def panel_row(*panel_option_hashes)
    num_panels = panel_option_hashes.length
    markup do |m|
      m.div id: 'sum_box', class: 'row mbl stats-container' do
        num_panels.times do |n|
          panel_body(m, panel_option_hashes[n])
        end
      end
    end
  end
      
  
  def panel_body(options)
    markup do |m|
      m.div class: 'col-sm-6 col-md-3' do
        m.div class: 'panel db mbm' do
          m.div class: 'panel-body' do
            m.p class: 'icon' do
              if options[:icon]
                m.i class: "#{options[:icon]}"
              else
                m.i ''
              end
            end
            m.h4 class: 'value' do
              if options[:value]
                m.span options[:value]
              else
                m.span
              end
            end
            if options[:description]
              m.p options[:description], class: 'description'
            else
              m.p class: 'description'
            end
          end
        end
      end
    end
  end
  
  def big_panel(options)
    markup do |m|
      m.div class: 'col-lg-8 col-lg-offset-2 col-md-8 col-md-offset-2' do
        m.div class: 'panel' do
          m.div class: 'panel-body' do
            m.div class: 'row' do
              m.div class: 'col-md-8' do
                m.h4 options[:title], class: 'mbs'
                m.p options[:title_subtext]
                m.div id: 'area-chart-spline', style: "width: 100%; height: 300px"
              end
              m.div class: 'col-md-4' do
              m.h4 options[:right_title], class: 'mbm'
              end
            end
          end
        end
      end
    end
  end 
  
  def data
    data = {
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
        {
            label: "My First dataset",
            fillColor: "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
            label: "My Second dataset",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [28, 48, 40, 19, 86, 27, 90]
        }
      ]
    }
    return data 
  end
  
  def options
    options = {}
    return options
  end
  
end
