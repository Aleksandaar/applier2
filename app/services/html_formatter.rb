require "html_pipeline" # must be included
require "html_pipeline/convert_filter/markdown_filter" # included because you want to use this filter
require "html_pipeline/node_filter/mention_filter" # included because you want to use this filter

class HtmlFormatter
  class << self
    def call(content)
      pipeline.call(content)[:output].to_s.html_safe
    end

    private 

      def pipeline
        @pipeline ||= HTMLPipeline.new(
          convert_filter: HTMLPipeline::ConvertFilter::MarkdownFilter.new,
            # note: next line is not needed as sanitization occurs by default;
            # see below for more info
          sanitization_config: HTMLPipeline::SanitizationFilter::DEFAULT_CONFIG,
          node_filters: [HTMLPipeline::NodeFilter::MentionFilter.new]
        )
      end
  end
end
