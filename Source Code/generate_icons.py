from PIL import Image
import os
import shutil

base = r"c:\Users\Nikhil Sahu\Downloads\codecanyon-TGDIJZQe-mova-movie-web-series-live-tv-streaming-flutter-app-script-with-admin-panel\Mova all file\Source Code"
logo_path = os.path.join(base, "admin", "admin", "frontend", "public", "webtime movie ocean logo.jpeg")

img = Image.open(logo_path)
print(f"Original logo size: {img.size}, mode: {img.mode}")

# Convert to RGBA for PNG support
if img.mode != 'RGBA':
    img = img.convert('RGBA')

flutter_base = os.path.join(base, "Flutter App", "mova", "mova")

# 1. Android mipmap icons (launcher + notification)
mipmap_sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

for folder, size in mipmap_sizes.items():
    folder_path = os.path.join(flutter_base, "android", "app", "src", "main", "res", folder)
    os.makedirs(folder_path, exist_ok=True)
    
    resized = img.resize((size, size), Image.LANCZOS)
    # Save as PNG (ic_launcher)
    launcher_path = os.path.join(folder_path, "ic_launcher.png")
    resized.save(launcher_path, "PNG")
    print(f"  Saved {launcher_path} ({size}x{size})")
    
    # Also save notification icon (same for now)
    notif_path = os.path.join(folder_path, "ic_notification.png")
    resized.save(notif_path, "PNG")
    print(f"  Saved {notif_path} ({size}x{size})")

# 2. Flutter assets/images/logo.png (512x512)
assets_logo = os.path.join(flutter_base, "assets", "images", "logo.png")
resized_512 = img.resize((512, 512), Image.LANCZOS)
resized_512.save(assets_logo, "PNG")
print(f"  Saved {assets_logo} (512x512)")

# 3. Web favicon (192x192)
web_favicon_path = os.path.join(flutter_base, "web", "favicon.png")
resized_192 = img.resize((192, 192), Image.LANCZOS)
resized_192.save(web_favicon_path, "PNG")
print(f"  Saved {web_favicon_path} (192x192)")

# 4. Web Icon-192.png
web_icon192_path = os.path.join(flutter_base, "web", "icons", "Icon-192.png")
os.makedirs(os.path.dirname(web_icon192_path), exist_ok=True)
resized_192.save(web_icon192_path, "PNG")
print(f"  Saved {web_icon192_path} (192x192)")

# 5. Web Icon-512.png
web_icon512_path = os.path.join(flutter_base, "web", "icons", "Icon-512.png")
resized_512.save(web_icon512_path, "PNG")
print(f"  Saved {web_icon512_path} (512x512)")

# 6. Web Icon-maskable-192.png
web_mask192_path = os.path.join(flutter_base, "web", "icons", "Icon-maskable-192.png")
resized_192.save(web_mask192_path, "PNG")
print(f"  Saved {web_mask192_path} (192x192)")

# 7. Web Icon-maskable-512.png
web_mask512_path = os.path.join(flutter_base, "web", "icons", "Icon-maskable-512.png")
resized_512.save(web_mask512_path, "PNG")
print(f"  Saved {web_mask512_path} (512x512)")

# 8. Admin panel logos
admin_public = os.path.join(base, "admin", "admin", "frontend", "public")
# logo192.png
resized_192.save(os.path.join(admin_public, "logo192.png"), "PNG")
print(f"  Saved admin logo192.png (192x192)")
# logo512.png  
resized_512.save(os.path.join(admin_public, "logo512.png"), "PNG")
print(f"  Saved admin logo512.png (512x512)")
# movie.png (used as favicon in admin)
resized_512.save(os.path.join(admin_public, "movie.png"), "PNG")
print(f"  Saved admin movie.png (512x512)")

# 9. Admin component assets logo
admin_component_logo = os.path.join(base, "admin", "admin", "frontend", "src", "Component", "assets", "images", "logo.png")
resized_512.save(admin_component_logo, "PNG")
print(f"  Saved admin component logo.png (512x512)")

# 10. iOS AppIcon (1024x1024 for App Store, various sizes)
ios_assets = os.path.join(flutter_base, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
if os.path.exists(ios_assets):
    ios_sizes = [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024]
    for size in ios_sizes:
        resized_ios = img.resize((size, size), Image.LANCZOS)
        ios_icon_path = os.path.join(ios_assets, f"Icon-App-{size}x{size}.png")
        resized_ios.save(ios_icon_path, "PNG")
        print(f"  Saved iOS icon {size}x{size}")
    # Also overwrite any existing icon files
    for f in os.listdir(ios_assets):
        if f.endswith('.png'):
            existing = os.path.join(ios_assets, f)
            # Get the size of existing file
            try:
                existing_img = Image.open(existing)
                w, h = existing_img.size
                existing_img.close()
                resized_ios = img.resize((w, h), Image.LANCZOS)
                resized_ios.save(existing, "PNG")
                print(f"  Replaced iOS icon {f} ({w}x{h})")
            except:
                pass
else:
    print(f"  iOS AppIcon folder not found at {ios_assets}")

print("\n✅ All icons generated successfully!")
