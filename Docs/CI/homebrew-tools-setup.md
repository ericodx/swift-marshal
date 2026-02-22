# Homebrew Tap Setup

Guide to configure automatic Homebrew formula updates on each release.

---

## homebrew-tools Repository

**URL:** https://github.com/new

### Create repository

1. Name: `homebrew-tools`
2. Visibility: **Public**
3. Click **Create repository**

### Create formula

Create the file `Formula/swift-marshal.rb`:

```ruby
class SwiftMarshal < Formula
  desc "CLI tool for organizing Swift type members"
  homepage "https://github.com/ericodx/swift-marshal"
  url "https://github.com/ericodx/swift-marshal/releases/download/v1.0.0/swift-marshal-v1.0.0-macos.tar.gz"
  sha256 "placeholder"

  def install
    bin.install "swift-marshal"
  end
end
```

---

## Personal Access Token

**URL:** https://github.com/settings/personal-access-tokens

### Create token

1. Click **Generate new token**
2. Fill in the fields:

| Field | Value |
|-------|-------|
| Token name | `swift-marshal-tap-token` |
| Description | `Token to update Homebrew tap formula via release workflow.` |
| Resource owner | `ericodx` |
| Expiration | 90 days |
| Repository access | Only select repositories |
| Select repositories | `ericodx/homebrew-tools` |

3. Under **Permissions → Repository permissions**, configure:

| Permission | Level |
|------------|-------|
| Contents | Read and write |
| Pull requests | Read and write |

4. Click **Generate token**
5. **Copy the token** (it won't be shown again)

---

## swift-marshal Repository

**URL:** https://github.com/ericodx/swift-marshal/settings/secrets/actions

### Create secret

1. Click **New repository secret**
2. Fill in the fields:

| Field | Value |
|-------|-------|
| Name | `HOMEBREW_TOOLS_GITHUB_TOKEN` |
| Secret | (paste the token copied above) |

3. Click **Add secret**

---

## Verification

After completing all configurations, test by creating a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Verify:
1. swift-marshal Actions ran successfully
2. PR was created in the homebrew-tools repository

---

## Troubleshooting

**PR not created:**
- Verify the token has access to the `homebrew-tools` repository
- Verify Contents and Pull requests permissions are set to "Read and write"

**Permission denied error:**
- Regenerate the token with correct permissions
- Verify the `HOMEBREW_TOOLS_GITHUB_TOKEN` secret was saved correctly
