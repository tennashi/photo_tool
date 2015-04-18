# -*- coding: utf-8; -*-

require 'rubygems'
require 'bundler/setup'

class Tool
    def initialize
        @flags = {}
        disable_mode :noop
        disable_mode :verbose
        disable_mode :test
        disable_mode :help
    end

    def disable_mode(type)
        set_mode type, false
    end

    def enable_mode(type)
        set_mode type, true
    end

    def set_mode(type, enabled)
        @flags[type] = enabled
        info "#{enabled ? 'Enabled' : 'Disabled'} #{type} mode."
    end

    def is_mode?(type)
        @flags[type]
    end

    def error(msg)
        STDERR.puts '[ERROR] ' + msg
        exit 1
    end

    def warning(msg)
        STDERR.puts '[WARNING] ' + msg if is_mode?(:verbose)
    end

    def info(msg)
        STDOUT.puts '[INFO] ' + msg if is_mode?(:verbose)
    end

    def need_root_or_exit
        if `id -u`.to_i != 0 then
            error 'need root privilege!'
        end
    end
end
