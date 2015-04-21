require 'formula'
require 'shellwords'

class SplunkForwarder < Formula
  homepage 'http://www.splunk.com'
  url 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=Macos&version=6.2.2&product=splunk_light&filename=splunklight-6.2.2-255606-macosx-10.7-intel.dmg&wget=true'
  # sha1 '7a6074edf8f67f442b9a2e853ba2912a1283731a'
  keg_only 'Splunk forwarder includes an invasive number of binaries and support files.'

  def caveats
    <<-EOS.undent
      This formula installs a wrapper executable at #{wrapper}. The
      wrapper sets SPLUNK_HOME to #{prefix} and
      launches #{real}.
    EOS
  end

  def install
    prefix.install Dir['*']
    install_wrapper
  end

  def test
    system 'splunk'
  end

  private

  def install_wrapper
    wrapper.open 'w' do |f|
      f.puts <<-EOS.undent
        #!/bin/bash
        SPLUNK_HOME=#{prefix.to_s.shellescape}
        #{real.to_s.shellescape} "$@"
      EOS
    end
    wrapper.chmod 0755
  end

  def real
    bin.join 'splunk'
  end

  def wrapper
    HOMEBREW_PREFIX.join 'bin', 'splunk'
  end
end
