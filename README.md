# Swift Marshal

[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![CI](https://img.shields.io/github/actions/workflow/status/ericodx/swift-marshal/main-analysis.yml?branch=main&style=flat-square&logo=github&logoColor=white&label=CI&color=4CAF50)](https://github.com/ericodx/swift-marshal/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=coverage)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)

**Reorder Swift type members without altering logic or formatting.**

Swift Marshal is an AST-based CLI that enforces a consistent member ordering within Swift type declarations. It reports violations with `check` and applies fixes with `fix` — both driven by SwiftSyntax and a declarative configuration file.
