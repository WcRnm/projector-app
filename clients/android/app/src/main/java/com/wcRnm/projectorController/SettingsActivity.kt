package com.wcRnm.projectorController

import android.os.Bundle
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.PreferenceManager

class SettingsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.settings_activity)
        supportFragmentManager
            .beginTransaction()
            .replace(R.id.settings, SettingsFragment())
            .commit()
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
    }

    class SettingsFragment : PreferenceFragmentCompat() {
        override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
            setPreferencesFromResource(R.xml.root_preferences, rootKey)

            val prefs = PreferenceManager.getDefaultSharedPreferences(this.context)

            // Set the read-only properties as summaries
            findPreference<Preference>(StringProp.ERROR.key)     ?.summary = prefs.getString(StringProp.ERROR.key, "?")
            findPreference<Preference>(StringProp.SW_VERSION.key)?.summary = prefs.getString(StringProp.SW_VERSION.key, "?")
            findPreference<Preference>(StringProp.RESOLUTION.key)?.summary = prefs.getString(StringProp.RESOLUTION.key, "?")

        }
    }

    override fun onOptionsItemSelected(item: MenuItem) = when (item.itemId) {
        R.id.action_settings -> {
            // User chose the "Settings" item, show the app settings UI...
            true
        }
        else -> {
            super.onOptionsItemSelected(item)
        }
    }
}