require "#{Rails.root}/lib/modules/generate_metrics.rb"

namespace :metrics do
  desc "automatically populate metrics"
  task generate_metrics: :environment do
    gen_metrics = GenerateMetrics.new
    gen_metrics.get_service_id
    gen_metrics.get_metric_list
    gen_metrics.create_metrics
  end
end