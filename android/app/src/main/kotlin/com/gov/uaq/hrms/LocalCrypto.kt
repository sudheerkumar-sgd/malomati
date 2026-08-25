package com.gov.uaq.hrms

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

object LocalCrypto {
    private const val ANDROID_KEYSTORE = "AndroidKeyStore"
    private const val WRAP_ALIAS = "malomati_hive_wrap_aes_gcm"
    private const val PREFS = "malomati_crypto"
    private const val WRAPPED_KEY = "hive_aes256_gcm_key"
    private const val GCM_TAG_BITS = 128
    private const val IV_LEN = 12
    private const val KEY_LEN = 32

    fun getOrCreateHiveKey(context: Context): ByteArray {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val wrapKey = getOrCreateWrapKey()
        val stored = prefs.getString(WRAPPED_KEY, null)
        if (stored != null) {
            return unwrap(wrapKey, Base64.decode(stored, Base64.NO_WRAP))
        }
        val dataKey = ByteArray(KEY_LEN)
        SecureRandom().nextBytes(dataKey)
        prefs.edit()
            .putString(WRAPPED_KEY, Base64.encodeToString(wrap(wrapKey, dataKey), Base64.NO_WRAP))
            .apply()
        return dataKey
    }

    private fun getOrCreateWrapKey(): SecretKey {
        val ks = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
        (ks.getEntry(WRAP_ALIAS, null) as? KeyStore.SecretKeyEntry)?.let {
            return it.secretKey
        }
        val keyGen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, ANDROID_KEYSTORE)
        keyGen.init(
            KeyGenParameterSpec.Builder(
                WRAP_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build()
        )
        return keyGen.generateKey()
    }

    private fun wrap(wrapKey: SecretKey, dataKey: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, wrapKey)
        val iv = cipher.iv
        return iv + cipher.doFinal(dataKey)
    }

    private fun unwrap(wrapKey: SecretKey, blob: ByteArray): ByteArray {
        val iv = blob.copyOfRange(0, IV_LEN)
        val ct = blob.copyOfRange(IV_LEN, blob.size)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, wrapKey, GCMParameterSpec(GCM_TAG_BITS, iv))
        return cipher.doFinal(ct)
    }
}
