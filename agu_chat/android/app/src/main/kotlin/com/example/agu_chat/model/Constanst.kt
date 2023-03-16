package com.example.agu_chat.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.lang.reflect.Type

object Constanst {
    var TOKEN: String = ""
    const val HUB_URL: String = "http://192.168.1.9:5291/hubs/"
    var currentUsername: String = ""

    var contacts = ArrayList<Member>()

    fun <T> arrayToString(list: List<T>?): String? {
        val g = Gson()
        return g.toJson(list)
    }

    fun <T> objectToString (member: T?):String?{
        val g = Gson()
        return g.toJson(member)
    }

    inline fun <reified T> parseArray(json: String, typeToken: Type): T {
        val gson = GsonBuilder().create()
        return gson.fromJson<T>(json, typeToken)
    }

    /*fun <T> stringToArray(s: String?, clazz: Class<Array<T>>?): MutableList<Array<T>> {
        val arr = Gson().fromJson(s, clazz)
        return Arrays.asList(arr)
    }*/

    /*
    fun test() {
    val json: String = "......."
    val type = object : TypeToken<List<MyObject>>() {}.type
    val result: List<MyObject> = parseArray<List<MyObject>>(json = json, typeToken = type)
    println(result)
}
    * */
}