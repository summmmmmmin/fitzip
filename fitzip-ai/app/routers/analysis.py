import io
import cv2
import numpy as np
import mediapipe as mp
from fastapi import APIRouter, File, UploadFile, HTTPException
from PIL import Image

from app.schemas import AnalysisResult, LandmarkPoint
from app.body_classifier import classify_body_type

router = APIRouter()

mp_pose = mp.solutions.pose


@router.post("/body-type", response_model=AnalysisResult)
async def analyze_body_type(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="이미지 파일만 업로드 가능합니다.")

    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    frame = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

    with mp_pose.Pose(
        static_image_mode=True,
        model_complexity=2,
        min_detection_confidence=0.5,
    ) as pose:
        results = pose.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))

    if not results.pose_landmarks:
        raise HTTPException(status_code=422, detail="인체를 감지하지 못했습니다. 전신이 보이는 사진을 사용해주세요.")

    raw_landmarks = results.pose_landmarks.landmark

    # 핵심 랜드마크 가시성 검증 (어깨, 엉덩이)
    required = [11, 12, 23, 24]
    for idx in required:
        if raw_landmarks[idx].visibility < 0.5:
            raise HTTPException(
                status_code=422,
                detail="어깨나 엉덩이가 잘 보이지 않습니다. 정면에서 전신이 나오도록 찍어주세요.",
            )

    body_type, confidence, measurements = classify_body_type(raw_landmarks)

    landmarks_out = [
        LandmarkPoint(
            x=lm.x, y=lm.y, z=lm.z, visibility=lm.visibility
        )
        for lm in raw_landmarks
    ]

    return AnalysisResult(
        body_type=body_type,
        confidence=confidence,
        landmarks=landmarks_out,
        **measurements,
    )
