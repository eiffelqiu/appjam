module Appjam
  module View
    extend self

    # Enables hirb and reads a config file from the main repo's config/hirb.yml.
    def enable
      unless @enabled
        Hirb::View.enable(:config_file=>File.join(Appjam.repo.config_dir, 'hirb.yml'))
        Hirb::Helpers::Table.filter_any = true
      end
      @enabled = true
    end

    # Renders any object via Hirb. Options are passed directly to
    # {Hirb::Console.render_output}[http://tagaholic.me/hirb/doc/classes/Hirb/Console.html#M000011].
    def render(object, options={}, return_obj=false)
      if options[:inspect]
        puts(object.inspect)
      else
        render_object(object, options, return_obj) unless silent_object?(object)
      end
    end

    #:stopdoc:
    def class_config(klass)
      opts = (Hirb::View.formatter_config[klass] || {}).dup
      opts.delete(:ancestor)
      opts.merge!((opts.delete(:options) || {}).dup)
      OptionParser.make_mergeable!(opts)
      opts
    end

    def toggle_pager
      Hirb::View.toggle_pager
    end

    def silent_object?(obj)
      [nil,false,true].include?(obj)
    end

    def render_object(object, options={}, return_obj=false)
      options[:class] ||= :auto_table
      render_result = Hirb::Console.render_output(object, options)
      return_obj ? object : render_result
    end
    #:startdoc:
  end
end
