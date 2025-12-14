"""
Glamora App Icon Generator
Generates app icons for all platforms with the advanced Glamora logo design
"""

from PIL import Image, ImageDraw, ImageFont
import math

def create_gradient_background(width, height):
    """Create multi-color gradient background"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)
    
    # Define gradient colors (matching Flutter theme)
    colors = [
        (248, 215, 196),  # #F8D7C4 - Peach
        (236, 72, 153),   # #EC4899 - Pink
        (168, 85, 247),   # #A855F7 - Purple
        (139, 92, 246),   # #8B5CF6 - Deep Purple
    ]
    
    # Create diagonal gradient
    for y in range(height):
        for x in range(width):
            # Calculate position (0.0 to 1.0)
            t = (x + y) / (width + height)
            
            # Find which color segment we're in
            segment = t * (len(colors) - 1)
            idx = int(segment)
            if idx >= len(colors) - 1:
                r, g, b = colors[-1]
            else:
                # Interpolate between two colors
                local_t = segment - idx
                c1 = colors[idx]
                c2 = colors[idx + 1]
                
                r = int(c1[0] + (c2[0] - c1[0]) * local_t)
                g = int(c1[1] + (c2[1] - c1[1]) * local_t)
                b = int(c1[2] + (c2[2] - c1[2]) * local_t)
            
            img.putpixel((x, y), (r, g, b))
    
    return img

def draw_sparkles(draw, center_x, center_y, radius, count=12):
    """Draw sparkle/star rays - beauty shimmer effect"""
    for i in range(count):
        angle = (i * 360 / count) * math.pi / 180
        length = radius if i % 2 == 0 else radius * 0.65
        start_radius = radius * 0.25
        
        start_x = center_x + start_radius * math.cos(angle)
        start_y = center_y + start_radius * math.sin(angle)
        end_x = center_x + length * math.cos(angle)
        end_y = center_y + length * math.sin(angle)
        
        draw.line(
            [(start_x, start_y), (end_x, end_y)],
            fill=(255, 255, 255, 150),
            width=3
        )
        
        # Draw dot at the end
        draw.ellipse(
            [end_x - 3, end_y - 3, end_x + 3, end_y + 3],
            fill=(255, 255, 255, 180)
        )

def draw_beauty_icons(draw, center_x, center_y, size):
    """Draw lipstick, scissors, and makeup brush - clear beauty symbols"""
    
    # Draw lipstick (center)
    lipstick_width = size * 0.15
    lipstick_height = size * 0.35
    lipstick_x = center_x - lipstick_width / 2
    lipstick_y = center_y - lipstick_height / 2
    
    # Lipstick body
    draw.rounded_rectangle(
        [
            lipstick_x, lipstick_y + lipstick_height * 0.2,
            lipstick_x + lipstick_width, lipstick_y + lipstick_height
        ],
        radius=int(lipstick_width * 0.1),
        fill=(255, 255, 255, 80)
    )
    
    # Lipstick tip
    draw.ellipse(
        [
            lipstick_x - lipstick_width * 0.05, lipstick_y,
            lipstick_x + lipstick_width * 1.05, lipstick_y + lipstick_height * 0.3
        ],
        fill=(255, 255, 255, 100)
    )
    
    # Draw scissors (right) - salon symbol
    scissor_size = size * 0.12
    scissor_x = center_x + size * 0.18
    scissor_y = center_y - size * 0.08
    
    # Scissor handles (circles)
    draw.ellipse(
        [scissor_x - scissor_size/2, scissor_y - scissor_size/2,
         scissor_x + scissor_size/2, scissor_y + scissor_size/2],
        outline=(255, 255, 255, 120),
        width=2
    )
    draw.ellipse(
        [scissor_x - scissor_size/2, scissor_y + scissor_size,
         scissor_x + scissor_size/2, scissor_y + scissor_size * 2],
        outline=(255, 255, 255, 120),
        width=2
    )
    
    # Scissor blades
    draw.line(
        [(scissor_x, scissor_y), (scissor_x + scissor_size * 1.2, scissor_y - scissor_size * 0.8)],
        fill=(255, 255, 255, 120),
        width=2
    )
    draw.line(
        [(scissor_x, scissor_y + scissor_size * 1.5), 
         (scissor_x + scissor_size * 1.2, scissor_y + scissor_size * 2.3)],
        fill=(255, 255, 255, 120),
        width=2
    )
    
    # Draw makeup brush (left)
    brush_x = center_x - size * 0.22
    brush_y = center_y + size * 0.05
    
    # Brush handle
    draw.line(
        [(brush_x, brush_y), (brush_x - size * 0.1, brush_y - size * 0.15)],
        fill=(255, 255, 255, 100),
        width=2
    )
    
    # Brush bristles
    for i in range(5):
        offset = i * 2
        draw.line(
            [(brush_x - size * 0.1 - offset, brush_y - size * 0.15),
             (brush_x - size * 0.15 - offset, brush_y - size * 0.22)],
            fill=(255, 255, 255, 80),
            width=1
        )

def draw_mirror_frame(draw, center_x, center_y, size):
    """Draw vanity mirror frame with lights"""
    
    # Draw oval mirror frame
    mirror_width = size * 0.7
    mirror_height = size * 0.75
    draw.ellipse(
        [center_x - mirror_width/2, center_y - mirror_height/2,
         center_x + mirror_width/2, center_y + mirror_height/2],
        outline=(255, 255, 255, 60),
        width=3
    )
    
    # Inner frame detail
    draw.ellipse(
        [center_x - mirror_width*0.4, center_y - mirror_height*0.42,
         center_x + mirror_width*0.4, center_y + mirror_height*0.42],
        outline=(255, 255, 255, 40),
        width=2
    )
    
    # Vanity lights around mirror
    for i in range(8):
        angle = (i * 45) * math.pi / 180
        light_x = center_x + (mirror_width * 0.45) * math.cos(angle)
        light_y = center_y + (mirror_height * 0.48) * math.sin(angle)
        draw.ellipse(
            [light_x - 3, light_y - 3, light_x + 3, light_y + 3],
            fill=(255, 255, 255, 80)
        )

def create_app_icon(size):
    """Create a single app icon of specified size - Clean Professional Design"""
    # Create gradient background
    img = create_gradient_background(size, size)
    
    # Create overlay for drawing
    overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    
    center_x = size // 2
    center_y = size // 2
    
    # Draw main circle background (white inner circle for clarity)
    draw.ellipse(
        [size * 0.15, size * 0.15, size * 0.85, size * 0.85],
        fill=(255, 255, 255, 40)
    )
    
    # PROFESSIONAL BEAUTY ICONS (Using simple shapes)
    
    # 1. LIPSTICK (Top Center) - Most recognizable beauty symbol
    lipstick_width = size * 0.08
    lipstick_height = size * 0.25
    lipstick_x = center_x - lipstick_width / 2
    lipstick_y = size * 0.2
    
    # Lipstick body (rectangle)
    draw.rectangle(
        [lipstick_x, lipstick_y + lipstick_height * 0.3,
         lipstick_x + lipstick_width, lipstick_y + lipstick_height],
        fill=(255, 255, 255, 255)
    )
    
    # Lipstick tip (triangle/rounded)
    draw.ellipse(
        [lipstick_x - lipstick_width * 0.2, lipstick_y,
         lipstick_x + lipstick_width * 1.2, lipstick_y + lipstick_height * 0.4],
        fill=(255, 100, 150, 255)  # Pink lipstick color
    )
    
    # 2. SCISSORS (Bottom Left) - Hair cutting symbol
    scissor_x = center_x - size * 0.18
    scissor_y = center_y + size * 0.15
    scissor_size = size * 0.15
    
    # Scissor handles (two circles)
    draw.ellipse(
        [scissor_x - scissor_size/3, scissor_y - scissor_size/3,
         scissor_x + scissor_size/3, scissor_y + scissor_size/3],
        outline=(255, 255, 255, 255),
        width=int(size * 0.015)
    )
    draw.ellipse(
        [scissor_x - scissor_size/3, scissor_y + scissor_size/2,
         scissor_x + scissor_size/3, scissor_y + scissor_size * 1.2],
        outline=(255, 255, 255, 255),
        width=int(size * 0.015)
    )
    
    # Scissor blades (lines)
    draw.line(
        [(scissor_x, scissor_y), (scissor_x + scissor_size, scissor_y - scissor_size * 0.5)],
        fill=(255, 255, 255, 255),
        width=int(size * 0.015)
    )
    draw.line(
        [(scissor_x, scissor_y + scissor_size * 0.8),
         (scissor_x + scissor_size, scissor_y + scissor_size * 1.3)],
        fill=(255, 255, 255, 255),
        width=int(size * 0.015)
    )
    
    # 3. MAKEUP BRUSH (Bottom Right) - Beauty application
    brush_x = center_x + size * 0.18
    brush_y = center_y + size * 0.15
    brush_size = size * 0.12
    
    # Brush handle (line)
    draw.line(
        [(brush_x, brush_y), (brush_x, brush_y + brush_size * 1.5)],
        fill=(255, 255, 255, 255),
        width=int(size * 0.02)
    )
    
    # Brush head (oval)
    draw.ellipse(
        [brush_x - brush_size * 0.4, brush_y + brush_size * 1.2,
         brush_x + brush_size * 0.4, brush_y + brush_size * 2],
        fill=(255, 200, 220, 255)
    )
    
    # 4. SPARKLE STAR (Top Right) - Glamour symbol
    star_x = center_x + size * 0.22
    star_y = center_y - size * 0.22
    star_size = size * 0.12
    
    # Draw 4-point star (sparkle)
    for angle in [0, 90, 180, 270]:
        angle_rad = angle * 3.14159 / 180
        x1 = star_x
        y1 = star_y
        x2 = star_x + star_size * 0.8 * math.cos(angle_rad)
        y2 = star_y + star_size * 0.8 * math.sin(angle_rad)
        draw.line([(x1, y1), (x2, y2)], fill=(255, 215, 0, 255), width=int(size * 0.015))
    
    # Center dot of star
    draw.ellipse(
        [star_x - star_size * 0.15, star_y - star_size * 0.15,
         star_x + star_size * 0.15, star_y + star_size * 0.15],
        fill=(255, 215, 0, 255)
    )
    
    # 5. "G" Letter (Center) - Brand identity
    try:
        font_size = int(size * 0.35)
        font = ImageFont.truetype("arialbd.ttf", font_size)
    except:
        font = ImageFont.load_default()
    
    text = "G"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    text_x = center_x - text_width // 2
    text_y = center_y - text_height // 2 - bbox[1]
    
    # Draw G with shadow
    draw.text(
        (text_x + 2, text_y + 2),
        text,
        font=font,
        fill=(0, 0, 0, 100)
    )
    draw.text(
        (text_x, text_y),
        text,
        font=font,
        fill=(255, 255, 255, 255)
    )
    
    # Composite overlay onto background
    img_rgba = img.convert('RGBA')
    img_rgba = Image.alpha_composite(img_rgba, overlay)
    
    # Add rounded corners (circle shape)
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([(0, 0), (size, size)], fill=255)
    
    # Create final image with rounded corners
    output = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    output.paste(img_rgba, (0, 0), mask)
    
    return output

def main():
    """Generate all icon sizes"""
    print("🎨 Generating Glamora app icons...")
    
    # Icon sizes needed
    sizes = {
        'web': [192, 512],
        'android': [48, 72, 96, 144, 192],
        'ios': [40, 60, 76, 120, 152, 167, 180, 1024]
    }
    
    import os
    
    # Create web icons
    web_dir = 'web/icons'
    os.makedirs(web_dir, exist_ok=True)
    
    for size in sizes['web']:
        icon = create_app_icon(size)
        filename = f'{web_dir}/Icon-{size}.png'
        icon.save(filename, 'PNG')
        print(f'✓ Created {filename}')
        
        # Create maskable version (add padding for safety area)
        maskable = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        icon_size = int(size * 0.8)  # 80% for safe area
        icon_resized = icon.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
        offset = (size - icon_size) // 2
        maskable.paste(icon_resized, (offset, offset), icon_resized)
        
        maskable_filename = f'{web_dir}/Icon-maskable-{size}.png'
        maskable.save(maskable_filename, 'PNG')
        print(f'✓ Created {maskable_filename}')
    
    # Create favicon
    favicon = create_app_icon(32)
    favicon.save('web/favicon.png', 'PNG')
    print(f'✓ Created web/favicon.png')
    
    # Create Android icons
    android_densities = {
        48: 'mdpi',
        72: 'hdpi',
        96: 'xhdpi',
        144: 'xxhdpi',
        192: 'xxxhdpi'
    }
    
    for size, density in android_densities.items():
        android_dir = f'android/app/src/main/res/mipmap-{density}'
        os.makedirs(android_dir, exist_ok=True)
        
        icon = create_app_icon(size)
        filename = f'{android_dir}/ic_launcher.png'
        icon.save(filename, 'PNG')
        print(f'✓ Created {filename}')
    
    print("\n✨ All icons generated successfully!")
    print("🎯 App icon is now set with the advanced Glamora logo")

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"❌ Error: {e}")
        print("Note: This script requires PIL/Pillow library")
        print("Install with: pip install Pillow")
