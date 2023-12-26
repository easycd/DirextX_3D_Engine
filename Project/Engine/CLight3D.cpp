#include "pch.h"
#include "CLight3D.h"

#include "CRenderMgr.h"
#include "CTransform.h"

CLight3D::CLight3D()
	: CComponent(COMPONENT_TYPE::LIGHT3D)
{
}

CLight3D::~CLight3D()
{
}

void CLight3D::finaltick()
{
	m_LightInfo.vWorldPos = Transform()->GetWorldPos();
	m_LightInfo.vWorldDir = Transform()->GetWorldDir(DIR_TYPE::FRONT);

	CRenderMgr::GetInst()->RegisterLight3D(m_LightInfo);
}

void CLight3D::SaveToLevelFile(FILE* _File)
{
}

void CLight3D::LoadFromLevelFile(FILE* _File)
{
}
