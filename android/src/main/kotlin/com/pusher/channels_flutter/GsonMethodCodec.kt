package com.pusher.channels_flutter

import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodCodec
import java.nio.ByteBuffer

class GsonMethodCodec : MethodCodec {
    private val gson = Gson()

    private fun encodeJson(data:Any): ByteBuffer {
        val json = gson.toJson(data)
        val byteArray = json.toByteArray(Charsets.UTF_8)
        val buf = ByteBuffer.allocateDirect(byteArray.size)
        buf.put(byteArray)
        return buf
    }

    override fun encodeMethodCall(methodCall: MethodCall?): ByteBuffer {
        if (methodCall != null) {
            return encodeJson( mapOf(
                "method" to methodCall.method,
                "args" to methodCall.arguments
            ))
        }
        throw Error("Failed to encode methodcall")
    }

    override fun decodeMethodCall(methodCall: ByteBuffer?): MethodCall {
        if (methodCall != null) {
            val buf = Charsets.UTF_8.decode(methodCall)
            val decoded = gson.fromJson(buf.toString(), Map::class.java)
            return MethodCall(decoded["method"] as String, decoded["args"])
        }
        throw Error("Cannot decode message")
    }

    override fun encodeSuccessEnvelope(result: Any?): ByteBuffer {
        return encodeJson(listOf(result))
    }

    override fun encodeErrorEnvelope(
        errorCode: String?,
        errorMessage: String?,
        errorDetails: Any?
    ): ByteBuffer {
        return encodeJson(listOf(errorCode, errorMessage, errorDetails))
    }

    override fun encodeErrorEnvelopeWithStacktrace(
        errorCode: String?,
        errorMessage: String?,
        errorDetails: Any?,
        errorStacktrace: String?
    ): ByteBuffer {
        return encodeJson(listOf(errorCode, errorMessage, errorDetails, errorStacktrace))
    }

    override fun decodeEnvelope(envelope: ByteBuffer?): Any {
        if (envelope != null) {
            val buf = Charsets.UTF_8.decode(envelope)
            return gson.fromJson(buf.toString(), Map::class.java)
        }
        throw Error("Cannot decode envelope")
    }
}