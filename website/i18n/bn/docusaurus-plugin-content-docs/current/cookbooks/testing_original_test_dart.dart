import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// একটি কাউন্টার ইমপ্লিমেন্ট এবং টেস্টেড শুধুমাত্র ডার্ট ব্যবহার করে (ফ্লাটার এর উপর নির্ভর না হয়ে)

// আমরা প্রভাইডার গ্লোবালি ডিক্লার করেছি, এবং আমরা এটি দুইটি টেস্ট এ ব্যবহার করব, এটি দেখার জন্য যে,
// স্টেটটা সঠিকভাবে '0' তে রিসেট হই কিনা, টেস্টগুলার মধ্যে

final counterProvider = StateProvider((ref) => 0);

// এখানে mockito ব্যবহার করা হচ্ছে, এটি ট্র্যাক করার জন্য যে কখন একটি প্রভাইডার
// লিসেনার গুলা কে নটিফাই করে
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // একটি অবজেক্ট যা আমাদের প্রভাডার রিড করতে সাহায্য করবে
    // টেস্ট এর মাঝে এটি কখনো শেয়ার করবেন না.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // একটি প্রভাইডার অবসারব করে এবং পরির্বতন গুলা গোয়েন্দাগিরি করে
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // এই লিসেনারটা সাথে সাথে কল হবে 0 এর সাথে, যেটি ডিফল্ট ভ্যালু
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // আমরা ভ্যালু টা বাড়ালাম
    container.read(counterProvider.notifier).state++;

    // লিসেনার আবার কল করা গেল তবে এবার '1' এর সাথে
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // আমরা এবার এখানে ভিন্ন ধরনের ProviderContainer ব্যবহার করব, প্রভাইডার রিড করার জন্য
    // এটি আমাদের নিশ্চয়তা দেই যে, এখানে টেস্ট এর মধ্যে অন্য কোন স্টেট ব্যবহার হচ্ছে না
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // নতুন টেস্ট সঠিকভাবে ডিফল্ট ভ্যালুটি ব্যবহার করে: 0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
