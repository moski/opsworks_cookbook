OpsWorks Cookbooks

## Wordpress

The wordpress cookbook allows you to deploy wordpress with a single click. All the keys configuration will be auto generated using the custom stack json.

For example, To deploy a website called example.com, you will add the fillowing json to the stack setting:

```json
{
	"deploy": {
		"wp_staging": {
		  	"hostname": "example.com",
				"database":{
					"database": "dbname",
					"username": "dbuser",
					"password": "dbpassword",
					"host": "dbHOST"
				},
				"authentication": {
					"auth_key": "",
					"secret_auth_key": "",
					"logged_in_key": "",
					"nonce_key": "",
					"auth_salt": "",
					"secure_auth_salt": "",
					"logged_in_salt": "",
					"nonce_salt": ""
				},
				"aws": {
					"s3_access_key": "S3_ACCESS_KEY",
					"s3_secret_key": "S3_SECRET_KEY"
				},
				"symlinks": {
					"config/keys.php": "keys.php",
					"config/health-check.php": "wp-content/themes/THEME/health-check.php"
				}
		}
	}
}
```

## Notes

1. For [authentication keys values](https://api.wordpress.org/secret-key/1.1/salt/)
2. In Symlink the path for the health-check.php should be inside the theme, so replace "Theme" with your theme name.
3. Wordpress wp-config.php should be something similar to:

```php
<?php
require "keys.php";

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
```

keys.php will auto generated and linked with each deploy.

OpsWorks and Chef will do the rest.
