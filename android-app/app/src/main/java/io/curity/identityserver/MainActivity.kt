package io.curity.identityserver

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import io.curity.identityserver.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)

        val model: MainActivityViewModel by viewModels()
        this.binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        this.binding.model = model

        //val navHostFragment = supportFragmentManager.findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        //navHostFragment.navController.navigate(R.id.fragment_authenticated, null)
    }
}