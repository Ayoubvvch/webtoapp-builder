#!/bin/bash

# =============================================================================
# سكريبت رفع المشروع إلى GitHub وبناء APK تلقائياً
# =============================================================================

echo "=============================================="
echo "  رفع مشروع الرياضيات الفيدية إلى GitHub"
echo "=============================================="
echo ""

# التحقق من وجود Git
if ! command -v git &> /dev/null; then
    echo "[خطأ] Git غير مثبت!"
    echo "يرجى تثبيت Git من: https://git-scm.com/"
    exit 1
fi

echo "[✓] Git متاح"

# التحقق من وجود GitHub CLI
if ! command -v gh &> /dev/null; then
    echo ""
    echo "⚠️  GitHub CLI غير مثبت."
    echo "  يمكنك:"
    echo "  1. تثبيت GitHub CLI: https://cli.github.com/"
    echo "  2. أو رفع المشروع يدوياً عبر متصفح GitHub"
    echo ""
    echo "سأقوم بإنشاء تعليمات للرفع اليدوي..."
    
    cat << 'MANUAL_UPLOAD'

================================================================================
                      تعليمات الرفع اليدوي إلى GitHub
================================================================================

1. إنشاء مستودع جديد على GitHub:
   - اذهب إلى: https://github.com/new
   - اسم المستودع: vedic-math-app
   - اختر: Public
   - لا تضف README/.gitignore/license الآن
   - انقر: "Create repository"

2. رفع الملفات:

   الطريقة الأولى (باستخدام GitHub CLI إذا ثبت):
   ```bash
   gh repo create vedic-math-app --public --source=. --push
   ```

   الطريقة الثانية (Git مباشر):
   ```bash
   git init
   git add .
   git commit -m "مشروع الرياضيات الفيدية - تطبيق Android"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/vedic-math-app.git
   git push -u origin main
   ```

3. تفعيل بناء APK:
   - اذهب إلى تبويب "Actions" في المستودع
   - ستجد "بناء تطبيق الرياضيات الفيدية" معروضاً
   - انقر على "Run workflow" لبناء APK

4. تحميل APK:
   - بعد انتهاء البناء (2-5 دقائق)
   - اذهب إلى تبويب "Actions"
   - انقر على اسم workflow
   - ستجد "artifacts" في الأسفل
   - انقر على "vedic-math-app.apk" للتحميل

================================================================================
MANUAL_UPLOAD
    exit 0
fi

# إذا كان GitHub CLI متاحاً
echo ""
echo "جاري إنشاء المستودع على GitHub..."

# طلب اسم المستخدم
read -p "أدخل اسم مستخدم GitHub الخاص بك: " GH_USER

if [ -z "$GH_USER" ]; then
    echo "[خطأ] اسم المستخدم مطلوب!"
    exit 1
fi

# إنشاء المستودع
echo ""
echo "[1/4] إنشاء المستودع..."
gh repo create vedic-math-app --public --description "تطبيق الرياضيات الفيدية - Vedic Math Android App" --source=. --push

if [ $? -ne 0 ]; then
    echo ""
    echo "[⚠️] المستودع ربما موجود بالفعل أو حدث خطأ."
    echo "    جاري إضافة remote وتحديث..."
    git remote add origin https://github.com/$GH_USER/vedic-math-app.git 2>/dev/null || true
    git push -u origin main
fi

echo ""
echo "[✓] تم رفع الكود بنجاح!"

# تشغيل workflow
echo ""
echo "[2/4] تشغيل عملية البناء..."

gh workflow run build.yml --ref main

if [ $? -eq 0 ]; then
    echo "[✓] تم تشغيل البناء بنجاح!"
else
    echo "[⚠️] يمكن تشغيل البناء يدوياً من تبويب Actions"
fi

echo ""
echo "=============================================="
echo "  تم إنشاء المستودع وبدء البناء!"
echo "=============================================="
echo ""
echo "الخطوات التالية:"
echo ""
echo "1. انتقل إلى: https://github.com/$GH_USER/vedic-math-app/actions"
echo ""
echo "2. انتظر حتى تنتهي العملية (2-5 دقائق)"
echo "   - المرحلة الأولى: تنزيل JDK و Android SDK"
echo "   - المرحلة الثانية: بناء التطبيق"
echo "   - المرحلة الثالثة: رفع ملف APK"
echo ""
echo "3. لتحميل APK:"
echo "   - اذهب إلى تبويب 'Actions'"
echo "   - انقر على 'بناء تطبيق الرياضيات الفيدية'"
echo "   - ستجد 'artifacts' في الأسفل"
echo "   - انقر على 'vedic-math-app.apk'"
echo ""
echo "رابط المستودع:"
echo "https://github.com/$GH_USER/vedic-math-app"
echo ""
echo "=============================================="
