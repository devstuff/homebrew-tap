# typed: false
# frozen_string_literal: true

class FeatureHelpers < Formula
  desc 'Git feature branch management scripts with JIRA/GitHub/GitLab/BitBucket integration'
  homepage 'https://github.com/devstuff/feature-helpers'
  # Update url and sha256 when publishing a release tarball.
  # url "https://github.com/devstuff/feature-helpers/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "..."
  license 'MIT'
  head 'https://github.com/devstuff/feature-helpers.git', branch: 'main'

  # Runtime dependencies (recommended; features degrade gracefully without them).
  depends_on 'bash' => :build # Requires Bash 4.3+; macOS ships 3.x.

  def install
    # Install all executable scripts directly to bin/.
    executables = Dir['*'].select { |f| File.executable?(f) && File.file?(f) }
    bin.install(*executables)
  end

  test do
    system "#{bin}/git-default-branch"
  end
end
