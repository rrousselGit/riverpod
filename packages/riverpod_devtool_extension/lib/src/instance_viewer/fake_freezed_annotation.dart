// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file contains annotations that behaves like package:freezed_annotation.
// This allows using Freezed without having the devtool depend on the package.
// We could instead remove the annotations, but that would make the process of
// updating the generated files tedious.

const nullable = Object();
const freezed = Object();

class Default {
  const Default(Object value);
}

class Assert {
  const Assert(String exp);
}

class JsonKey {
  const JsonKey({
    bool? ignore,
    Object? defaultValue,
  });
}
