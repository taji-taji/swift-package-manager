//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2014-2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArgumentParser
import TSCBasic
import Workspace

struct ComputeChecksum: SwiftCommand {
    static let configuration = CommandConfiguration(
        abstract: "Compute the checksum for a binary artifact.")

    @OptionGroup(_hiddenFromHelp: true)
    var globalOptions: GlobalOptions

    @Argument(help: "The absolute or relative path to the binary artifact")
    var path: AbsolutePath

    func run(_ swiftTool: SwiftTool) throws {
        let binaryArtifactsManager = try Workspace.BinaryArtifactsManager(
            fileSystem: swiftTool.fileSystem,
            authorizationProvider: swiftTool.getAuthorizationProvider(),
            hostToolchain: swiftTool.getHostToolchain(),
            checksumAlgorithm: SHA256(),
            customHTTPClient: .none,
            customArchiver: .none,
            delegate: .none
        )
        let checksum = try binaryArtifactsManager.checksum(forBinaryArtifactAt: path)
        print(checksum)
    }
}
