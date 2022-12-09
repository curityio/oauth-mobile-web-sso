package io.curity.identityserver.client

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.navigation.fragment.NavHostFragment
import io.curity.identityserver.client.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)

        val model: MainActivityViewModel by viewModels()
        this.binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        this.binding.model = model
    }

    fun navigateToAuthenticatedView() {
        val navHostFragment = supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        print("NAVIGATE ***")
        navHostFragment.navController.navigate(R.id.fragment_authenticated)
    }
}
