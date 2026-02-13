# QA Documentation Generator

**Automated QA documentation generation with PowerShell**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows%2011-blue.svg)](https://www.microsoft.com/windows)
[![PowerShell: 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/powershell/)

---

## 🎯 Overview

A PowerShell-based tool that automatically generates professional QA documentation in Markdown format. Simply input your data in a JSON file, and the script creates a fully formatted, professional document.

**Key Features:**
- ⚡ **80% time savings** - 15 minutes → 2 minutes per document
- 📋 **Consistent formatting** - Always professional
- 🔄 **Reproducible** - Same data = same document
- 💾 **Version control friendly** - JSON + Markdown in Git
- 🔒 **GDPR compliant** - Local processing, no cloud

---

## 📋 Supported Document Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Bug Ticket** | Systematic bug documentation | Track and document bugs with all relevant details |
| **Test Protocol** | Comprehensive test reports | Document test results, statistics, and findings |
| **Solution Concept** | Structured solution proposals | Present technical solutions with analysis |
| **Analysis Report** | Professional analysis documents | Document findings and recommendations |
| **Test Cases** | Organized test case collections | Structure and document test scenarios |

---

## 🚀 Quick Start

### Prerequisites

- Windows 10/11
- PowerShell 5.1 or higher (pre-installed on Windows)

### Installation

1. **Clone the repository**
   ```powershell
   git clone https://github.com/tibo47-161/qa-documentation-generator.git
   cd qa-documentation-generator
   ```

2. **Set execution policy** (first time only)
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Test the installation**
   ```powershell
   .\Generate-QADocument.ps1 -ConfigFile "examples\bug_ticket.json" -Template "BugTicket"
   ```

### Quick Start Menu

For the easiest experience, use the interactive menu:

```batch
# Double-click SCHNELLSTART.bat or run:
.\SCHNELLSTART.bat
```

---

## 📝 Usage

### Basic Usage

```powershell
# Generate a bug ticket
.\Generate-QADocument.ps1 -ConfigFile "my_bug.json" -Template "BugTicket"

# Generate a test protocol
.\Generate-QADocument.ps1 -ConfigFile "my_test.json" -Template "TestProtokoll"

# Specify output path
.\Generate-QADocument.ps1 -ConfigFile "bug.json" -Template "BugTicket" -OutputPath "output\bug_3690.md"
```

### Creating Your Own Documents

1. **Copy a template**
   ```
   templates\bug_ticket.json → my_bug.json
   ```

2. **Edit the JSON file**
   - Open `my_bug.json` in your favorite editor
   - Fill in all fields (see examples for reference)
   - Save the file

3. **Generate the document**
   ```powershell
   .\Generate-QADocument.ps1 -ConfigFile "my_bug.json" -Template "BugTicket"
   ```

4. **Done!** 🎉
   - Find your generated Markdown document in the same folder
   - Copy to Azure DevOps Wiki, GitHub, or your documentation system

---

## 📂 Project Structure

```
qa-documentation-generator/
├── Generate-QADocument.ps1      # Main PowerShell script
├── SCHNELLSTART.bat             # Interactive quick-start menu
├── README.md                    # This file
├── LICENSE                      # MIT License
├── docs/
│   ├── ANLEITUNG_Windows11.md   # Complete guide (German)
│   └── USAGE.md                 # Detailed usage examples
├── templates/
│   ├── bug_ticket.json          # Empty bug ticket template
│   ├── test_protocol.json       # Empty test protocol template
│   └── solution_concept.json   # Empty solution concept template
└── examples/
    ├── bug_ticket.json          # Example bug ticket with data
    └── test_protocol.json       # Example test protocol with data
```

---

## 🎨 Example: Bug Ticket

**Input:** `bug_3690.json`
```json
{
  "Titel": "Offline login blocked",
  "BugID": "3690",
  "Schweregrad": "Critical",
  "Zusammenfassung": "App blocks login in flight mode despite offline features.",
  ...
}
```

**Output:** `bug_3690.md`
```markdown
# Bug Ticket: Offline login blocked

**Bug-ID:** #3690
**Severity:** Critical
**Status:** Open

## Summary
App blocks login in flight mode despite offline features.

## Description
When the device is in flight mode, the app shows the error message...
...
```

**Time saved:** 15 minutes → 2 minutes ⚡

---

## 💡 Benefits

### For Individuals
- ⚡ **80% time savings** on documentation
- 📋 **Consistent format** - always professional
- 🔄 **Reproducible** - same data = same document
- 💾 **Version control** - JSON + MD in Git

### For Teams
- 🤝 **Common standards** - everyone uses the same templates
- 📈 **Scalable** - 1 bug ticket or 100 bug tickets
- 🎯 **Quality assurance** - no forgotten fields
- 🔄 **Onboarding** - new team members get started quickly

### For Organizations
- 💰 **Cost savings** - reduced documentation time
- 📊 **Metrics** - measurable efficiency gains
- 🔒 **Compliance** - GDPR compliant (local processing)
- 🎯 **Standardization** - consistent documentation across teams

---

## 🛠️ Advanced Usage

### Batch Processing

Create a batch file to generate multiple documents:

**`generate_all_bugs.bat`**
```batch
@echo off
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "bug_3684.json" -Template "BugTicket"
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "bug_3685.json" -Template "BugTicket"
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "bug_3686.json" -Template "BugTicket"
echo Done!
```

### Integration with Azure DevOps

```powershell
# Generate document
.\Generate-QADocument.ps1 -ConfigFile "bug.json" -Template "BugTicket" -OutputPath "output.md"

# Copy to Azure DevOps Wiki
$content = Get-Content "output.md" -Raw
# Use Azure DevOps API to create/update Wiki page
```

### Git Integration

```batch
@echo off
echo Generating document...
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "bug.json" -Template "BugTicket"

echo Committing to Git...
git add *.md
git commit -m "Generated bug ticket"
git push

echo Done!
```

---

## 📖 Documentation

- **[Complete Guide (German)](docs/ANLEITUNG_Windows11.md)** - Step-by-step installation and usage
- **[Usage Examples](docs/USAGE.md)** - Detailed examples for all document types
- **[Template Reference](docs/TEMPLATES.md)** - JSON structure for each template

---

## 🔧 Troubleshooting

### "Script cannot be loaded"

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "JSON file not found"

**Solution:**
- Check if the JSON file is in the same folder as the script
- Or provide the full path to the file

### "Invalid JSON format"

**Solution:**
- Open the JSON file in VS Code
- Check for missing commas, quotes, or brackets
- Use an online validator: https://jsonlint.com

For more troubleshooting, see the [Complete Guide](docs/ANLEITUNG_Windows11.md).

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

**Areas for contribution:**
- New document templates
- Additional language support
- Integration with other tools (Jira, GitHub Issues, etc.)
- Performance improvements
- Bug fixes

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**QA Engineer** | Passionate about test automation and quality assurance

- GitHub: [@tibo47-161](https://github.com/tibo47-161)
- Email: tobi196183@gmail.com

---

## 🙏 Acknowledgments

- Inspired by the need for efficient QA documentation
- Built with PowerShell for Windows environments
- Designed for integration with Azure DevOps

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/tibo47-161/qa-documentation-generator?style=social)
![GitHub forks](https://img.shields.io/github/forks/tibo47-161/qa-documentation-generator?style=social)
![GitHub issues](https://img.shields.io/github/issues/tibo47-161/qa-documentation-generator)

---

**Made with ❤️ for the QA community**
