package com.qa.crmService.utils;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class TestDataGenerator {

    private static final Random random = new Random();

    public static Map<String, Object> generateUserData() {
        Map<String, Object> user = new HashMap<>();
        user.put("name", "Test User " + System.currentTimeMillis());
        user.put("username", "testuser" + random.nextInt(10000));
        user.put("email", "test" + System.currentTimeMillis() + "@example.com");
        user.put("phone", "1-770-736-8031 x" + random.nextInt(10000));
        user.put("website", "hildegard.org");

        Map<String, Object> address = new HashMap<>();
        address.put("street", "Kulas Light");
        address.put("suite", "Apt. 556");
        address.put("city", "Gwenborough");
        address.put("zipcode", "92998-3874");

        user.put("address", address);

        return user;
    }

    public static Map<String, Object> generatePostData() {
        Map<String, Object> post = new HashMap<>();
        post.put("title", "Test Post " + System.currentTimeMillis());
        post.put("body", "This is a test post body created at " + System.currentTimeMillis());
        post.put("userId", random.nextInt(10) + 1);

        return post;
    }
}